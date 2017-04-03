//
//  RoomDetailViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class RoomDetailViewModel :  BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    var reloadBinding: ReloadBinding?
    private let metroarea: String
    private let roomsList: RoomList
    private let room: Room
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, metroarea: String, roomsList: RoomList, room: Room) {
        self.metroarea = metroarea
        self.roomsList = roomsList
        self.room = room
        self.authenticator = authenticator
        self.fetcher = fetcher
    }
    
    func title() -> String {
        return "Selected Room"
    }
    
    func roomname() -> String {
        return room.name
    }
    
    func roomPicture() -> URL? {
        guard let picture = room.picture else {
            return nil
        }
        return URL(string: picture)
    }
}
