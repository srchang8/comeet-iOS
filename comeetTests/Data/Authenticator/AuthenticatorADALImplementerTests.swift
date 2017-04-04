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
        authenticator!.handle(result: nil, error: nil, completion: { (token: String?, error: Error?, type: AuthType) in
            XCTAssert(error == nil)
            XCTAssert(token == nil)
        })
    }
    
    func testDeleteCookies() {
        let cookieName = "CookieName"
        let cookieJar = HTTPCookieStorage.shared
        let cookie = HTTPCookie.init(properties: [HTTPCookiePropertyKey.name : cookieName,
                                                  HTTPCookiePropertyKey.value : "value",
                                                  HTTPCookiePropertyKey.domain : "test.domain.com",
                                                  HTTPCookiePropertyKey.path : "fakepath"])
        cookieJar.setCookie(cookie!)
        let cookiesNum = cookieJar.cookies!.count
        authenticator!.deleteCookies(cookiesNames: [cookieName])
        
        XCTAssert(cookieJar.cookies!.count == cookiesNum - 1)
    }
    
    func testNoOrganization() {
        let organization = authenticator?.getOrganization()
        XCTAssert(organization == "organization")
    }
    
    func testOrganizationChange() {
        let organization = AuthenticatorUtils.getUserOrganization(email: "test@something.com")
        XCTAssert(organization == "something.com")
    }
    
    func testOrganizationInvalidChange() {
        let organization = AuthenticatorUtils.getUserOrganization(email: "test_something.com")
        XCTAssert(organization == nil)
    }
}
