//
//  LoginViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

typealias TokenBinding = (String)-> Void
typealias TokenErrorBinding = (Error)-> Void

class LoginViewModel {
    
    public var tokenBinding: TokenBinding?
    public var tokenErrorBinding: TokenErrorBinding?
    internal var authenticator = DataSimpleBridge.getAuthenticator()
    
    func getToken() {
        authenticator.getToken { [weak self] (token: String?, error: Error?) in
            guard error == nil else {
                self?.tokenErrorBinding?(error!)
                return
            }
            
            if let token = token {
                self?.tokenBinding?(token)
            }
        }
    }
}
