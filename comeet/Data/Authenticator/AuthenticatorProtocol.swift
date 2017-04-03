//
//  AuthenticatorProtocol.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

typealias TokenCompletion = (String?, Error?, AuthType)-> Void

enum AuthType {
    case basic
    case oauth2
}

protocol AuthenticatorProtocol {
    func getToken(completion:@escaping TokenCompletion)
    func isLoggedIn() -> Bool
    func logout()
    func getOrganization() -> String
}
