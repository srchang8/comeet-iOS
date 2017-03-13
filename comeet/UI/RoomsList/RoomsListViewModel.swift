//
//  RoomsListViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

typealias RoomsBinding = ([Room])-> Void

class RoomsListViewModel : BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    var roomsBinding: RoomsBinding?
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol) {
        self.authenticator = authenticator
        self.fetcher = fetcher
    }
    
    func fetchRooms() {
        fetcher.fetchRooms { [weak self] (rooms, error) in
            guard error == nil else {
                print(error!)
                return
            }
            if let rooms = rooms {
                self?.roomsBinding?(rooms)
            } else {
                print("fetcher.fetchRooms returned nil")
            }
        }
    }
}
