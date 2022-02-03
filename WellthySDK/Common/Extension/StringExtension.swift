//
//  StringExtension.swift
//  WellthySDK
//
//  Created by Praphin SP on 03/02/22.
//

import Foundation

extension String {

    var isNameValid:Bool {
        if count > 3 {
            let characterSet = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz. ")
            return rangeOfCharacter(from: characterSet.inverted) == nil
        }
        return false

    }
    
    var isValidMobileNo: Bool {
        if self.hasOnlyNumbers, (self.count >= 8 && self.count <= 12), let noInt = Int(self), noInt > 10000000 {
            return true
        }
        else {
            return false
        }
    }
    
    var hasOnlyNumbers: Bool {
        let characterSet = NSCharacterSet(charactersIn: "0123456789१२३४५६७८९०")
        return rangeOfCharacter(from: characterSet.inverted) == nil
    }
    
    func isValidEmail() -> Bool {
        
        // Mail id Reg-Ex check.
        let testEmail = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testEmail)
    }

    func addingUrlPercentEncoding() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
    }


}
