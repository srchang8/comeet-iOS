//
//  FakeAuthenticator.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/19/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
@testable import comeet

class FakeAuthenticator: AuthenticatorProtocol
{
    public var token: String?
    public var error: Error?
    public var userLoggedIn = true
    public var organization = "organization"
    public var authType = AuthType.oauth2
    
    func getToken(completion:@escaping TokenCompletion) {
        completion(token, error, authType)
    }
    
    func isLoggedIn() -> Bool {
        return userLoggedIn
    }
    
    func logout() {
        
    }
    
    func getOrganization() -> String {
        return organization
    }
}
