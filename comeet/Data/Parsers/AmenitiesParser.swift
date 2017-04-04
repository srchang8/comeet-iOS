//
//  AmenitiesParser.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class AmenitiesParser {
    
    internal struct Constants {
        static let nameKey = "name"
        static let descriptionKey = "description"
    }
    
    static func parseAmenity(amenityDict: [AnyHashable : Any]) -> Amenity? {
        guard let name = amenityDict[Constants.nameKey] as? String,
            let description = amenityDict[Constants.descriptionKey] as? String else {
                return nil
        }
        
        let amenity = Amenity(name: name, description: description)
        return amenity
    }
    
    static func parseAmenities(amenitiesArray: [Any]) -> [Amenity] {
        var amenities: [Amenity] = []
        for amenityDict in amenitiesArray {
            if let amenityDict = amenityDict as? [AnyHashable : Any] {
                if let amenity = AmenitiesParser.parseAmenity(amenityDict: amenityDict) {
                    amenities.append(amenity)
                }
            }
        }
        return amenities
    }
}
