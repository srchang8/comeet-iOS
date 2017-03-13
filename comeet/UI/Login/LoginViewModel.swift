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

class LoginViewModel : BaseViewModel {
    
    var tokenBinding: TokenBinding?
    var tokenErrorBinding: TokenErrorBinding?
    var authenticator = DataSimpleBridge.getAuthenticator()
    
    func getToken() {
        authenticator.getToken { [weak self] (token: String?, error: Error?) in
            guard error == nil else {
                DispatchQueue.main.async {
                    self?.tokenErrorBinding?(error!)
                }
                return
            }
            
            if let token = token {
                DispatchQueue.main.async {
                    self?.tokenBinding?(token)
                }
            }
        }
    }
}
