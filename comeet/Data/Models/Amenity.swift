//
//  Amenity.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

struct Amenity : Equatable {
    let name: String
    let description: String
    
    public static func ==(lhs: Amenity, rhs: Amenity) -> Bool {
        return lhs.description == rhs.description && lhs.name == rhs.name
    }
}
