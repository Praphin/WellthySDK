//
//  OnboardingResource.swift
//  WellthySDK
//
//  Created by Praphin SP on 03/02/22.
//

import Foundation
import Alamofire

class OnboardingResource {
    
    func register(param: [String: Any], completion: @escaping ((_ code: Int, _ response: [String:Any]?, _ error: Error?)->Void)) {
            
        ApiResource().apiCallWithToken(urlStr: AuthData().getHostDataURL(type: .onBoarding), method: .post, header: nil, parameters: param, encoding: URLEncoding.default) { code, response, error in
            
            if code == SDKErrorCode.code_201, let dict = response as? [String:Any], let dataresponse = dict[SDKConstants.data] as? [String:Any]{
                
                if let data = try? JSONSerialization.data(withJSONObject: dataresponse, options: .prettyPrinted) {
                
                do {
                    let profData = try JSONDecoder().decode(ProfileData.self, from: data)
                    profData.save()
                    completion(code, profData.response(), nil)
                }
                catch {
                    DebugLogger().log(error.localizedDescription)
                    completion(SDKErrorCode.code_600,nil,nil)
                }
                }
            } else {
                completion(code, nil, error)
            }
        
        }

    }
    
}
