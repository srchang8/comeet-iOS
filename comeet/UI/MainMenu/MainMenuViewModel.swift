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
    let persistor: PersistorProtocol
    var selectedDate = Date()
    var reloadBinding: ReloadBinding?
    public var meetings: [Meeting] = []
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, persistor: PersistorProtocol) {
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.persistor = persistor
    }
    
    func title() -> String {
        return ""
    }
    
    func logout() {
        authenticator.logout()
        persistor.save(metroArea: nil)
    }
    
  
}
