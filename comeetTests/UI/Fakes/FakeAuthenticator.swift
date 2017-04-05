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
    public var organization = "organization"
    public var type = AuthType.oauth2
    
    func getToken(completion:@escaping TokenCompletion) {
        completion(token, error, type)
    }
    
    func hasToken() -> String? {
        return token
    }
    
    func logout() {
        
    }
    
    func getOrganization() -> String {
        return organization
    }
}
