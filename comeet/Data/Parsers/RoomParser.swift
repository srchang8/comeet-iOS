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
        static let pictureKey = "picture"
        static let navigationKey = "navigation"
        static let amenitiesKey = "amenities"
        static let freebusyKey = "freebusy"
    }
    
    static func parseRoom(roomDict: [AnyHashable : Any]) -> Room? {
        
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
        var picture: String?
        if let pictureValue = roomDict[Constants.pictureKey] as? String {
            picture = pictureValue
        }
        var navigation: String?
        if let navigationValue = roomDict[Constants.navigationKey] as? String {
            navigation = navigationValue
        }
        var amenities: [Amenity]? = nil
        if let amenitiesArray = roomDict[Constants.amenitiesKey] as? [Any] {
            amenities = AmenitiesParser.parseAmenities(amenitiesArray: amenitiesArray)
        }
        
        var freebusy: [FreebusyBlock]? = nil
        if let freebusyBocksArray = roomDict[Constants.freebusyKey] as? [Any] {
            freebusy = FreebusyBlockParser.parseFreebusyBlocks(freebusyBlocksArray: freebusyBocksArray)
        }
        
        return Room(name: name,
                    email: email,
                    address: address,
                    country: country,
                    state: state,
                    metroarea: metroarea,
                    latitude: latitude,
                    longitude: longitude,
                    capacity: capacity,
                    picture: picture,
                    navigation: navigation,
                    amenities: amenities,
                    freebusy: freebusy)
    }
    
    static func parseRooms(roomsArray: [Any]) -> [Room] {
        var rooms:[Room] = []
        for roomDict in roomsArray {
            if let roomDict = roomDict as? [AnyHashable : Any] {
                if let room = parseRoom(roomDict: roomDict) {
                    rooms.append(room)
                }
            }
        }
        return rooms
    }
}
