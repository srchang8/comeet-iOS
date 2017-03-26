//
//  AmenitiesParserTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class AmenitiesParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInvalidAmenity() {
        let invalidAmenityDict = ["Nothing" : "Value"]
        let amenity = AmenitiesParser.parseAmenity(amenityDict: invalidAmenityDict)
        
        XCTAssert(amenity == nil)
    }
    
    func testValidAmenity() {
        let validAmenityDict = [AmenitiesParser.Constants.nameKey : "TV",
                                AmenitiesParser.Constants.descriptionKey : "Flat screen TV"]
        let amenity = AmenitiesParser.parseAmenity(amenityDict: validAmenityDict)
        
        XCTAssert(amenity != nil)
    }
}
