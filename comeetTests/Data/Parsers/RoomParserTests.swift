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
        let room = RoomParser.parseRoom(roomDict: Stubs.roomDict())
        
        XCTAssert(room!.name == Stubs.roomDict()[RoomParser.Constants.nameKey] as! String &&
            room!.email == Stubs.roomDict()[RoomParser.Constants.emailKey] as! String)
    }
    
    func testParseRooms() {
        XCTAssert(RoomParser.parseRooms(roomsArray: [["Nothing" : "Invalid"]]).count == 0)
        XCTAssert(RoomParser.parseRooms(roomsArray: [Stubs.roomDict()]).count == 1)
    }
}
