//
//  AuthenticatorADALImplementer.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import ADAL

class AuthenticatorADALImplementer : AuthenticatorProtocol {
    
    private struct Constants {
        static let authority = "https://login.microsoftonline.com/common"
        static let resource = "https://outlook.office365.com"
        static let clientId = "a64d56ea-5675-4ccf-82e9-5757620e1d26"
        static let redirectUri = URL(string: "http://localhost/comeet")
    }
    
    func getToken(completion:@escaping TokenCompletion) {
        var error: ADAuthenticationError?
        let authContext: ADAuthenticationContext = ADAuthenticationContext(authority: Constants.authority,
                                                                           error: &error)
        
        authContext.acquireToken(withResource: Constants.resource, clientId: Constants.clientId, redirectUri: Constants.redirectUri) { [weak self] (result: ADAuthenticationResult?) in
            self?.handle(result: result, error: error, completion: completion)
        }
    }  
}

internal extension AuthenticatorADALImplementer {
    
    func handle(result: ADAuthenticationResult?, error: ADAuthenticationError?, completion:@escaping TokenCompletion) {
        guard error == nil else {
            completion(nil, error)
            return
        }
        guard result?.status.rawValue == AD_SUCCEEDED.rawValue,
            let token = result?.accessToken else {
                completion(nil, error)
                return
        }
        completion(token, error)
    }
}
