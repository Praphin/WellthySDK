//
//  AuthResponse.swift
//  WellthySDK
//
//  Created by Praphin SP on 03/02/22.
//

import Foundation

class AuthData: Codable {
    
    var api_key: String?
    var api_limit: Int?
    var client_id: Int?
    var client_name: String?
    var services_data: [ServiceData]?
    var token: String?
    var whitelisted_package_names: [String]?

    enum CodingKeys: String, CodingKey {
        case api_key, api_limit, client_id, client_name, services_data, token, whitelisted_package_names
    }
    
    static var shared: AuthData? = {
        if let data = SDKVariables.shared.getValueFromUserDefault(key: SDKConstants.authData) as? Data, let authData = try? JSONDecoder().decode(AuthData.self, from: data) {
            return authData
        }
        return nil
    }()
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            SDKVariables.shared.saveValueInUserDefault(key: SDKConstants.authData, value: data)
            AuthData.shared = self
        }
    }

    func response() -> [String : Any] {
        var dict: [String : Any] = [:]
        dict["client_id"] = self.client_id
        dict["api_limit"] = self.api_limit
        return dict
    }
    
    func getHostData(type: HostDataType) -> ServiceData? {
        if let data = self.services_data?.filter({ data in
            return data.service == type.rawValue
        }).first {
            return data
        } else {
            return nil
        }
    }
    
    func getHostDataURL(type: HostDataType) -> String {
        return AuthData.shared?.getHostData(type: type)?.base_url ?? ""
    }

}

class ServiceData: Codable {
    var api_limit: Int?
    var base_url: String?
    var service: String?
    
    enum CodingKeys: String, CodingKey {
        case api_limit, base_url, service
    }

}

enum HostDataType: String {
    case onBoarding = "onboarding"
    case magazine = "magazine"
    case profile = "profile"
    case diary = "diary"
    case chat = "chat"
}
