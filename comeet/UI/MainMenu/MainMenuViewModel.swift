//
//  MainMenuViewModel.swift
//  comeet
//
//  Created by stephen chang on 3/9/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//


import Foundation

class MainMenuViewModel : BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol) {
        self.authenticator = authenticator
        self.fetcher = fetcher
    }
    
    func title() -> String {
        return "Menu"
    }
    
    func logout() {
        authenticator.logout()
    }
}
