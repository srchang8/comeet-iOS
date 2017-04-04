//
//  RoomsListViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class RoomsListViewModel : BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    var reloadBinding: ReloadBinding?
    private let metroarea: String
    private let roomsList: RoomList
    private var rooms: [Room] = []
    private var selectedDate = Date()
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, metroarea: String, roomsList: RoomList) {
        self.metroarea = metroarea
        self.roomsList = roomsList
        self.authenticator = authenticator
        self.fetcher = fetcher
    }
    
    func title() -> String {
        return "Rooms in " + roomsList.name
    }
    
    func dateString() -> String {
        return selectedDate.displayString()
    }
    
    func fetchRooms() {
        fetcher.getRooms(organization: authenticator.getOrganization(), roomlist: roomsList.email) { [weak self] (rooms, error) in
            guard error == nil else {
                print(error!)
                return
            }
            if let rooms = rooms {
                DispatchQueue.main.async {
                    self?.rooms = rooms
                    self?.reloadBinding?()
                }
            } else {
                print("fetcher.getRooms returned nil")
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
        if let capacity = room.capacity {
            return "Capacity: \(capacity)"
        }
        return room.email
    }
    
    func roomPicture(index: Int) -> URL? {
        guard rooms.count > index else {
            return nil
        }
        guard let picture = rooms[index].picture else {
            return nil
        }
        return URL(string: picture)
    }
    
    func room(index: Int) -> Room? {
        guard rooms.count > index else {
            return nil
        }
        return rooms[index]
    }
    
    func selected(date: Date) {
        selectedDate = date
        reloadBinding?()
    }
    
    func maxTimeInterval() -> TimeInterval {
        return 60 * 60 * 24 * 360
    }
    
    func availableRooms() -> [Room] {
        return rooms.filter({ (room) -> Bool in
            guard let freebusy = room.freebusy else {
                return false
            }
            return freebusy.containsFree(date: selectedDate)
        })
    }
}
