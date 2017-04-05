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
        return AuthenticatorBasicImplementer()
    }
    
    static func getFetcher() -> FetcherProtocol {
        return FetcherAlamofireImplementer()
    }
    
    static func getPersistor() -> PersistorProtocol {
        return PersistorUserDefaultsImplementer()
    }
}
