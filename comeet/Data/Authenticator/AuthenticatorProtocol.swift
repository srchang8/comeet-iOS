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
    var type: AuthType { get }
    func getToken(completion:@escaping TokenCompletion)
    func hasToken() -> String?
    func logout()
    func getOrganization() -> String
}
