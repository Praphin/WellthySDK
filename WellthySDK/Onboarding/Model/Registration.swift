//
//  Registration.swift
//  WellthySDK
//
//  Created by Praphin SP on 03/02/22.
//

import Foundation

public class Registration {

    /// Registration Module: Supports creating session for new user as well as already created user
    /// - Parameters:
    ///   - param: registration parametes need to be passed here ('phone', 'country_code')
    ///   - completion: returns success or failure
    public static func register(param: [String : Any], completion: @escaping ((_ code: Int, _ response: [String:Any]?, _ error: Error?)->Void)) {

        guard let _ = SDKVariables.shared.authToken() else {
            DebugLogger().log("INVALID CLIENT ID")
            completion(401, nil, nil)
            return
        }
        
        RegistrationBuilder().validate(data: param) { isValid in
           
            // data validation check on sdk
            if isValid {
                OnboardingResource().register(param: param) { code, response, error in
                    completion(code, response, error)
                }
            } else {
                completion(401, nil, nil)
            }
        }
    }

}
