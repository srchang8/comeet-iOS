//
//  DataSimpleBridge.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class DataSimpleBridge {
    
    static func getAuthenticator() -> AuthenticatorProtocol {
        let use_adal = UserDefaults.standard.bool(forKey: "use_adal")
        if use_adal {
            return AuthenticatorADALImplementer()
        } else {
            return AuthenticatorBasicImplementer()
        }
    }
    
    static func getFetcher() -> FetcherProtocol {
        return FetcherAlamofireImplementer()
    }
    
    static func getPersistor() -> PersistorProtocol {
        return PersistorUserDefaultsImplementer()
    }
}
