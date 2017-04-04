//
//  EnvironmentTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/14/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class EnvironmentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetRoomsMocked() {
        let environment: Environment = .Mocked
        let endpoints = Endpoints(environment: environment)
        
        XCTAssert(endpoints.getRooms(organization: "organization", roomlist: "test@test.com") == environment.rawValue + "/organization/roomlists/test%40test.com/rooms")
    }
    
    func testGetRoomsProduction() {
        let environment: Environment = .Production
        let endpoints = Endpoints(environment: environment)
        
        XCTAssert(endpoints.getRooms(organization: "organization", roomlist: "test@test.com") == environment.rawValue + "/organization/roomlists/test%40test.com/rooms")
    }
}
