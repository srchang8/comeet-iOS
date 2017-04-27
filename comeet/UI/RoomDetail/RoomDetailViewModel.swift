//
//  RoomDetailViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

typealias BookRoomBinding = (Bool)-> Void

class RoomDetailViewModel :  BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    private let loader = DataSimpleBridge.getLoader()
    var bookRoomBinding: BookRoomBinding?
    let startDate: Date
    let endDate: Date
    private let metroarea: String
    private let roomsList: User
    private let room: Room
    
    struct Constants {
        static let loadingText = "Booking"
    }
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, startDate: Date, endDate: Date, metroarea: String, roomsList: User, room: Room) {
        self.metroarea = metroarea
        self.roomsList = roomsList
        self.room = room
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func bookRoom(subject: String?, body: String?) {
        let finalSubject = subject ?? ""
        let finalBody = body ?? ""
        let requiredAtendees = room.email
        let params = fetcher.bookRoomParams(start: startDate.stringForAPI(), end: endDate.stringForAPI(), subject: finalSubject, body: finalBody, requiredAttendees: requiredAtendees)
        
        loader.show(text: Constants.loadingText)
        
        fetcher.bookRoom(organization: authenticator.getOrganization(), roomrecipient: room.email, params: params) { [weak self] (succes: Bool, error: Error?) in
            self?.loader.hide()
            self?.bookRoomBinding?(succes)
        }
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
    
    func roomFloorPlan() -> URL? {
        if let picture = room.navigation {
            return URL(string: picture)
        } else {
            return nil
        }
    }
    
    func roomLatLong() -> (Double, Double)? {
        if let lat = room.latitude,
            let long = room.longitude {
            return (lat, long)
        }
        return nil
    }
    
    func roomBookText() -> String {
        return "Book \(startDate.displayStringDate()) \(startDate.displayStringHourMinute())-\(endDate.displayStringHourMinute())"
    }
}
