//
//  RoomParser.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/11/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class RoomParser {
    
    internal struct Constants {
        static let nameKey = "name"
        static let emailKey = "email"
        static let addressKey = "address"
        static let countryKey = "country"
        static let stateKey = "state"
        static let metroareaKey = "metroarea"
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
        static let capacityKey = "capacity"
    }
    
    static func parseRoom(roomDict: NSDictionary) -> Room? {
        
        guard let name = roomDict[Constants.nameKey] as? String,
            let email = roomDict[Constants.emailKey] as? String else {
            return nil
        }
        var address: String?
        if let addressValue = roomDict[Constants.addressKey] as? String {
            address = addressValue
        }
        var country: String?
        if let countryValue = roomDict[Constants.countryKey] as? String {
            country = countryValue
        }
        var state: String?
        if let stateValue = roomDict[Constants.stateKey] as? String {
           state = stateValue
        }
        var metroarea: String?
        if let metroareaValue = roomDict[Constants.metroareaKey] as? String {
           metroarea = metroareaValue
        }
        var latitude: Double?
        if let latitudeValue = roomDict[Constants.latitudeKey] as? String {
           latitude = Double(latitudeValue)
        }
        var longitude: Double?
        if let longitudeValue = roomDict[Constants.longitudeKey] as? String {
           longitude = Double(longitudeValue)
        }
        var capacity: Int?
        if let capacityValue = roomDict[Constants.capacityKey] as? Int {
           capacity = capacityValue
        }
        
        return Room(name: name,
                    email: email,
                    address: address,
                    country: country,
                    state: state,
                    metroarea: metroarea,
                    latitude: latitude,
                    longitude: longitude,
                    capacity: capacity)
    }
    
    static func parseRooms(roomsArray: NSArray) -> [Room] {
        var rooms:[Room] = []
        for roomDict in roomsArray {
            if let roomDict = roomDict as? NSDictionary {
                if let room = parseRoom(roomDict: roomDict) {
                    rooms.append(room)
                }
            }
        }
        return rooms
    }
}
