//
//  AuthenticatorADALImplementerTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/7/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet
import ADAL

class AuthenticatorADALImplementerTests: XCTestCase {
    
    var authenticator: AuthenticatorADALImplementer?
    
    override func setUp() {
        super.setUp()
        authenticator = AuthenticatorADALImplementer()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHandleNil() {
        authenticator!.handle(result: nil, error: nil, completion: { (token: String?, error: Error?) in
            XCTAssert(error == nil)
            XCTAssert(token == nil)
        })
    }
}
