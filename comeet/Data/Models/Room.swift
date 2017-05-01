//
//  Room.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/11/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

struct Room: Equatable {
    
    let name: String
    let email: String
    let address: String?
    let country: String?
    let state: String?
    let metroarea: String?
    let latitude: Double?
    let longitude: Double?
    let capacity: Int?
    let picture: String?
    let navigation: String?
    let amenities: [Amenity]?
    let freebusy: [FreebusyBlock]?
    
    public static func ==(lhs: Room, rhs: Room) -> Bool {
        return lhs.email == rhs.email && lhs.name == rhs.name
    }
}
