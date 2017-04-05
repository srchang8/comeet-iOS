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
    let selectedDate: Date
    private let metroarea: String
    private let roomsList: RoomList
    private var rooms: [Room] = []
    internal var startDate : Date?
    internal var endDate : Date?
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, selectedDate: Date, metroarea: String, roomsList: RoomList) {
        self.metroarea = metroarea
        self.roomsList = roomsList
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.selectedDate = selectedDate
    }
    
    struct Constants {
        static let startDateText = "Select Start"
        static let endDateText = "Select End"
    }
    
    func title() -> String {
        return "Rooms in " + roomsList.name
    }
    
    func startDateString() -> String {
        return startDate?.displayString() ?? Constants.startDateText
    }
    
    func endDateString() -> String {
        return endDate?.displayString() ?? Constants.endDateText
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
        return availableRooms().count
    }
    
    func roomName(index: Int) -> String {
        guard availableRooms().count > index else {
            return ""
        }
        let room = availableRooms()[index]
        return room.name
    }
    
    func roomDescription(index: Int) -> String {
        guard availableRooms().count > index else {
            return ""
        }
        let room = availableRooms()[index]
        if let capacity = room.capacity {
            return "Capacity: \(capacity)"
        }
        return room.email
    }
    
    func roomPicture(index: Int) -> URL? {
        guard availableRooms().count > index else {
            return nil
        }
        guard let picture = availableRooms()[index].picture else {
            return nil
        }
        return URL(string: picture)
    }
    
    func room(index: Int) -> Room? {
        guard availableRooms().count > index else {
            return nil
        }
        return availableRooms()[index]
    }
    
    func start(date: Date) {
        startDate = date
        reloadBinding?()
    }
    
    func end(date: Date) {
        endDate = date
        reloadBinding?()
    }
    
    func maxTimeInterval() -> TimeInterval {
        return 60 * 60 * 24 * 360
    }
    
    func availableRooms() -> [Room] {
        guard let startDate = startDate,
            let endDate = endDate else {
                return rooms
        }
        
        return rooms.filter({ (room) -> Bool in
            guard let freebusy = room.freebusy else {
                return false
            }
            return freebusy.containsFree(date: startDate) && freebusy.containsFree(date: endDate)
        })
    }
}
