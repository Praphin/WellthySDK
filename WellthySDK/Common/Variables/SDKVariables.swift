//
//  SDKVariables.swift
//  WellthySDK
//
//  Created by Praphin SP on 03/02/22.
//

import Foundation

class SDKVariables: NSObject {
    
    static let shared: SDKVariables = SDKVariables()

    override init() {
        super.init()
    }

    lazy var sdkVersion:String = {
        
        guard let sdkVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String else {
            return ""
        }
        return sdkVersion
    }()

    lazy var buildNumber:String = {
        
        guard let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String else {
            return "1.0.0"
        }
        return buildNumber
    }()

    var SDK_CLIENT_ID:String? = {
        
        if let path = Bundle.main.path(forResource: "SDK-Info", ofType: "plist") {

            if let dictionary = NSDictionary(contentsOfFile: path) {

                if let clientID = dictionary["SDK_CLIENT_ID"] as? String {
                    DebugLogger().log("SDK_CLIENT_ID: \(clientID)")
                    return clientID
                }
            }
        }
        return nil
    }()

    var SDK_CLIENT_TOKEN:String? = {
        
        if let path = Bundle.main.path(forResource: "SDK-Info", ofType: "plist") {

            if let dictionary = NSDictionary(contentsOfFile: path) {

                if let clientToken = dictionary["SDK_CLIENT_TOKEN"] as? String {
                    DebugLogger().log("SDK_CLIENT_ID: \(clientToken)")
                    return clientToken
                }
            }
        }
        return nil
    }()
    
    var CLIENT_BUNDLE_ID:String? = {
        
        if let path = Bundle.main.path(forResource: "SDK-Info", ofType: "plist") {

            if let dictionary = NSDictionary(contentsOfFile: path) {

                if let bundleID = dictionary["BUNDLE_ID"] as? String {
                    DebugLogger().log("SDK_CLIENT_ID: \(bundleID)")
                    return bundleID
                }
            }
        }
        return nil
    }()
    
    var host:String = {
        
        guard let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String else {
            return "https://optimus.wellthy.me"
        }
        return "https://optimus.wellthy.me"
    }()
    
    func urlConstant(url: String) -> String {
        return host + url
    }
    
    func authToken() -> String? {
        if let token = getValueFromUserDefault(key: SDKConstants.authToken) as? String, token.count > 0 {
            return token
        }
        return nil
    }

    func saveValueInUserDefault(key k: String , value : Any?) {
        UserDefaults.standard.set(value, forKey:k)
        UserDefaults.standard.synchronize()
    }

    func getValueFromUserDefault(key k : String) -> Any? {
        return UserDefaults.standard.value(forKey: k)
    }


}
