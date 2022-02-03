//
//  AuthenticationResource.swift
//  WellthySDK
//
//  Created by Praphin SP on 03/02/22.
//

import Foundation

class AuthenticationResource {
    
    /// Authenticate SDK with the parent App
    func authenticate(completion: @escaping ((_ code: Int, _ response: [String:Any]?, _ error: Error?)->Void)) {
            
        var header = [String: String]()
        header["X-Api-Key"] = SDKVariables.shared.SDK_CLIENT_ID ?? ""
        header["X-Api-Secret"] = SDKVariables.shared.SDK_CLIENT_TOKEN ?? ""
        header["X-App-Bundle"] = SDKVariables.shared.CLIENT_BUNDLE_ID ?? ""

        ApiResource().apiCallWithToken(urlStr: SDKVariables().urlConstant(url: URLConstants.authURL), method: .post, header: header, parameters: nil) { (code, response, error) in

            if code == 200, let dict = response as? [String:Any], let dataresponse = dict[SDKConstants.data] as? [String:Any], let data = try? JSONSerialization.data(withJSONObject: dataresponse, options: .prettyPrinted) {
                
                do {
                    let authData = try JSONDecoder().decode(AuthData.self, from: data)
                        SDKVariables.shared.saveValueInUserDefault(key: SDKConstants.authToken, value: authData.token)
                    authData.save()
                    completion(code, authData.response(), nil)
                }
                catch {
                    DebugLogger().log(error.localizedDescription)
                    completion(SDKErrorCode.code_600,nil,nil)
                }
            } else {
                completion(SDKErrorCode.code_600,nil,nil)
            }
        }
    }
}
