//
//  RoomsListViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

typealias RoomsBinding = ()-> Void

class RoomsListViewModel : BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    var roomsBinding: RoomsBinding?
    private var rooms: [Room] = []
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol) {
        self.authenticator = authenticator
        self.fetcher = fetcher
    }
    
    func fetchRooms() {
        fetcher.getRooms { [weak self] (rooms, error) in
            guard error == nil else {
                print(error!)
                return
            }
            if let rooms = rooms {
                DispatchQueue.main.async {
                    self?.rooms = rooms
                    self?.roomsBinding?()
                }
            } else {
                print("fetcher.fetchRooms returned nil")
            }
        }
    }
    
    func roomsCount() -> Int {
        return rooms.count
    }
    
    func roomName(index: Int) -> String {
        guard rooms.count > index else {
            return ""
        }
        let room = rooms[index]
        return room.name
    }
    
    func roomDescription(index: Int) -> String {
        guard rooms.count > index else {
            return ""
        }
        let room = rooms[index]
        return room.email
    }
}
