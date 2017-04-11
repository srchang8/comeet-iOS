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
    var bookRoomBinding: BookRoomBinding?
    let startDate: Date
    let endDate: Date
    private let metroarea: String
    private let roomsList: User
    private let room: Room
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, startDate: Date, endDate: Date, metroarea: String, roomsList: User, room: Room) {
        self.metroarea = metroarea
        self.roomsList = roomsList
        self.room = room
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func bookRoomExample(){
        var request = URLRequest(url: URL(string: "https://api.meetl.ink:8443/comeet/meetl.ink/rooms/jablack@meetl.ink/reserve")!)
        
        request.httpMethod = "POST"
        
        request.setValue("Basic YOUR_TOKEN_HERE", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let postString = "start=2017-05-12T09:00:00-0400&end=2017-05-12T10:05:00-0400&subject=Science Class&body=Momentum and Gravity&required=jablack@meetl.ink, adminish@meetl.ink"
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
    func bookRoom() {
        let subject = "Comeet metting"
        let body = "This meeting was created by comeet"
        let requiredAtendees = [room.email]
        let optionalAttendees: [String]? = nil
        let params = fetcher.bookRoomParams(start: startDate.stringForAPI(), end: endDate.stringForAPI(), subject: subject, body: body, requiredAttendees: requiredAtendees, optionalAttendees: optionalAttendees)
        
        fetcher.bookRoom(organization: authenticator.getOrganization(), roomrecipient: room.email, params: params) { [weak self] (succes: Bool, error: Error?) in
            self?.bookRoomBinding?(succes)
        }
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
        return "Book \(startDate.displayStringDate()) \(startDate.displayStringHourMinute())-\(endDate.displayStringHourMinute())"
    }
}
