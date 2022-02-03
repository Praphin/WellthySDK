//
//  Authentication.swift
//  WellthySDK
//
//  Created by Praphin SP on 03/02/22.
//

import Foundation

/// Authenticate with SDK
public class Authentication {

    /// SDK will authenticate with app by reading paramters from parent app
    /// Paramters will read automatically from plist in parent app
    /// This function does not required any parameter as input.
    /// - Paramters:
    ///     - client id: client id allocated to each client.
    ///     - secret_token: token given for each client.
    /// - Response:
    ///         Returns success if authenticated else throw failure
    public static func authSDK(completion: @escaping ((_ code: Int, _ response: [String:Any]?, _ error: Error?)->Void)) {

        DebugLogger().log("SDK AUTHENTICATION STARTED")
        DebugLogger().log("Version: \(SDKVariables.shared.sdkVersion)")
        
        guard let _ = SDKVariables.shared.SDK_CLIENT_ID else {
            DebugLogger().log("INVALID CLIENT ID")
            completion(600, nil, nil)
            return
        }
        
        guard let _ = SDKVariables.shared.SDK_CLIENT_TOKEN else {
            DebugLogger().log("INVALID TOKEN")
            completion(600, nil, nil)
            return
        }
        
        AuthenticationResource().authenticate { code, response, error in
            completion(code, response, error)
        }

    }
}
