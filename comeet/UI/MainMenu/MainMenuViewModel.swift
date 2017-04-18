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
    private var meetings: [Meeting] = []
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, persistor: PersistorProtocol) {
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.persistor = persistor
    }
    
    func fetchMeetings() {
        let start = Date().stringForAPI()
        let end = Date().addingTimeInterval(60 * 60 * 24).stringForAPI()
        
        fetcher.getMeetings(organization: authenticator.getOrganization(), user: "", start: start, end: end) { [weak self] (meetings: [Meeting]?, error: Error?) in
            if let meetings = meetings {
                self?.meetings = meetings
                self?.reloadBinding?()
            }
        }
    }
    
    func title() -> String {
        return ""
    }
    
    func logout() {
        authenticator.logout()
        persistor.save(metroArea: nil)
    }
    
  
}

private extension MainMenuViewModel {
    }
