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
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOauth2AuthoricationHeader() {
        adapter = AlamofireAccessTokenAdapter(accessToken: "token", type: AuthType.oauth2)
        var request = URLRequest(url: URL(string:"http://www.test.com")!)
        
        do {
            request = try (adapter?.adapt(request))!
            let authorizationHeader = request.allHTTPHeaderFields!["Authorization"]
            XCTAssert(authorizationHeader == "Bearer token")
        } catch {
            XCTAssert(false)
        }
    }
    
    func testBasicAuthoricationHeader() {
        adapter = AlamofireAccessTokenAdapter(accessToken: "user/pass", type: AuthType.basic)
        var request = URLRequest(url: URL(string:"http://www.test.com")!)
        
        do {
            request = try (adapter?.adapt(request))!
            let authorizationHeader = request.allHTTPHeaderFields!["Authorization"]
            XCTAssert(authorizationHeader == "Basic user/pass")
        } catch {
            XCTAssert(false)
        }
    }
}
