//
//  RoomParserTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/14/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class RoomParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInvalidRoom() {
        let invalidRoomDict = ["Nothing" : "Invalid"]
        let room = RoomParser.parseRoom(roomDict: invalidRoomDict)
        
        XCTAssert(room == nil)
    }
    
    func testValidRoom() {
        let invalidRoomDict = [RoomParser.Constants.nameKey : "Name",
                               RoomParser.Constants.emailKey : "Email"]
        
        let room = RoomParser.parseRoom(roomDict: invalidRoomDict)
        
        XCTAssert(room?.name == "Name" && room?.email == "Email")
    }
}
