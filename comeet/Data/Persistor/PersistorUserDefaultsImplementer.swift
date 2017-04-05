//
//  PersistorUserDefaultsImplementer.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/4/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class PersistorUserDefaultsImplementer : PersistorProtocol {
    
    private struct Constants {
        static let credentialsKey = "credentialsKey"
    }
    
    func save(credentials: String?) {
        UserDefaults.standard.setValue(credentials, forKey: Constants.credentialsKey)
        UserDefaults.standard.synchronize()
    }
    
    func getCredentials() -> String? {
        return UserDefaults.standard.string(forKey: Constants.credentialsKey)
    }
}
