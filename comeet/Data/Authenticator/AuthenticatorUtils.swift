//
//  AuthenticatorUtils.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/2/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class AuthenticatorUtils {
    
    struct Constants {
        static let defaultOrganization = "organization"
    }
    
    class func getUserOrganization(email: String) -> String? {
        let components = email.components(separatedBy: "@")
        guard components.count == 2 else {
            return nil
        }
        return components[1]
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
