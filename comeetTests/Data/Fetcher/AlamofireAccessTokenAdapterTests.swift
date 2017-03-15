//
//  AlamofireAccessTokenAdapterTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/14/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class AlamofireAccessTokenAdapterTests: XCTestCase {
    
    var adapter: AlamofireAccessTokenAdapter?
    
    override func setUp() {
        super.setUp()
        adapter = AlamofireAccessTokenAdapter(accessToken: "token")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAuthoricationHeader() {
        var request = URLRequest(url: URL(string:"http://www.test.com")!)
        
        do {
            request = try (adapter?.adapt(request))!
            let authorizationHeader = request.allHTTPHeaderFields!["Authorization"]
            XCTAssert(authorizationHeader == "Bearer token")
        } catch {
            XCTAssert(false)
        }
    }
}
