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
    let startDate: Date
    let endDate: Date
    private let metroarea: String
    private let roomsList: RoomList
    private let room: Room
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, startDate: Date, endDate: Date, metroarea: String, roomsList: RoomList, room: Room) {
        self.metroarea = metroarea
        self.roomsList = roomsList
        self.room = room
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.startDate = startDate
        self.endDate = endDate
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
    
    func roomAddress() -> String {
        let address = room.address ?? ""
        return metroarea + "\n" + address
    }
    
    func roomAmenities() -> String {
        
        var amenitiesString = ""
        
        if let capacity = room.capacity {
            amenitiesString = "Capacity: \(capacity)"
        }
        
        if let amenities = room.amenities {
            for amenity in amenities {
                amenitiesString = amenitiesString + "\n\n" + "\(amenity.name): \(amenity.description)"
            }
        }

        return amenitiesString
    }
    
    func roomBookText() -> String {
        return "Book \(startDate.displayStringDate()) \(startDate.displayStringHour())-\(endDate.displayStringHour())"
    }
}
