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
        UserDefaults.standard.synchronize()
        let key = "use_adal"
        if let use_adal = UserDefaults.standard.value(forKey: key) as? Bool {
            return use_adal ? AuthenticatorADALImplementer() : AuthenticatorBasicImplementer()
        } else {
            return AuthenticatorADALImplementer()
        }
    }
    
    static func getFetcher() -> FetcherProtocol {
        return FetcherAlamofireImplementer()
    }
    
    static func getPersistor() -> PersistorProtocol {
        return PersistorUserDefaultsImplementer()
    }
    
    static func getLoader() -> LoaderProtocol {
        return LoaderALLoadingViewImplementer()
    }
}
