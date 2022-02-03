//
//  RegistrationResponse.swift
//  WellthySDK
//
//  Created by Praphin SP on 03/02/22.
//

import Foundation

class ProfileData: Codable {
    
    var id: Int?
    var name: String?
    var age: Int?
    var device_id: String?
    var device_type: String?
    var gender: String?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case id, name, age, device_id, device_type, gender, status
    }
    
    static var shared: ProfileData? = {
        if let data = SDKVariables.shared.getValueFromUserDefault(key: SDKConstants.profileData) as? Data, let authData = try? JSONDecoder().decode(ProfileData.self, from: data) {
            return authData
        }
        return nil
    }()
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            SDKVariables.shared.saveValueInUserDefault(key: SDKConstants.profileData, value: data)
            ProfileData.shared = self
        }
    }

    func response() -> [String : Any] {
        var dict: [String : Any] = [:]
        dict["id"] = self.id
        dict["name"] = self.name
        return dict
    }

}


//"activation_code" = "<null>";
//"activation_code_generation_id" = "<null>";
//"activation_code_id" = "<null>";
//"activity_level" = "<null>";
//"activity_level_entered_at" = "<null>";
//age = 0;
//"bmi_shown_at" = "<null>";
//"campaign_data_id" = "<null>";
//"client_data_fk" = "<null>";
//conditions = "<null>";
//"country_code" = 91;
//"created_at" = "2021-11-26T09:36:16.428Z";
//"delete_patient_code" = "<null>";
//"deleted_at" = "<null>";
//"device_id" = "<null>";
//"device_type" = "<null>";
//"device_version" = "<null>";
//dob = "<null>";
//email = "<null>";
//"expires_at" = "<null>";
//gender = "<null>";
//"has_activated_subscription" = 0;
//"has_hc_access" = 1;
//"has_paid_onetime_fees" = 0;
//"health_goals" = "<null>";
//height = 0;
//"height_unit" = "<null>";
//id = 75548;
//"image_url" = "<null>";
//"is_active" = 1;
//"is_bmi_shown" = 0;
//"is_deleted" = 0;
//"is_expired" = 0;
//"is_free" = 0;
//"is_patient_onboarded" = 0;
//"is_roche_verified" = 0;
//"is_test_patient" = 0;
//"knowledge_level" = "<null>";
//"knowledge_level_entered_at" = "<null>";
//"language_data_fk" = 1;
//"language_entered_at" = "<null>";
//"language_switched_at" = "<null>";
//"last_active_at" = "<null>";
//"migration_id" = "<null>";
//name = "<null>";
//nickname = "<null>";
//"novartis_disclaimer_accepted" = 0;
//"novartis_disclaimer_accepted_at" = "<null>";
//password = "<null>";
//"patient_onboarded_at" = "<null>";
//"patient_partner_id" = "<null>";
//phone = 9846789761;
//refreshtoken = "0e59fd50-446a-4721-847a-41af70065e43";
//"roche_email_entered_at" = "<null>";
//"roche_verified_at" = "<null>";
//status = ONBOARDED;
//therapyId = "<null>";
//"therapy_activated" = 0;
//"therapy_end_date" = "<null>";
//"therapy_id" = "<null>";
//"therapy_start_date" = "<null>";
//timezone = UTC;
//token = "0e59fd50-446a-4721-847a-41af70065e43";
//"updated_at" = "2021-11-26T09:36:16.428Z";
//weight = 0;
//"weight_unit" = "<null>";


