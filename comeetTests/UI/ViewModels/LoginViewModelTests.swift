//
//  LoginViewModelTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/7/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel?
    
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTokenChange() {

        let fakeAuthenticator = FakeAuthenticator()
        fakeAuthenticator.token = Stubs.token()
        viewModel?.authenticator = fakeAuthenticator
        
        viewModel!.tokenBinding = { (token: String) in
            XCTAssert(token == Stubs.token())
        }
        viewModel!.tokenErrorBinding = { (error: Error) in
            XCTAssert(false)
        }
        viewModel!.getToken()
    }
    
    func testTokenError() {
        
        let fakeAuthenticator = FakeAuthenticator()
        fakeAuthenticator.error = Stubs.unauthorizedError()
        viewModel?.authenticator = fakeAuthenticator
        
        viewModel!.tokenBinding = { (token: String) in
            XCTAssert(false)
        }
        viewModel!.tokenErrorBinding = { (error: Error) in
            XCTAssert(error.localizedDescription == Stubs.unauthorizedError().localizedDescription)
        }
        viewModel!.getToken()
    }
    
    func testIsLoggedIn() {
        let fakeAuthenticator = FakeAuthenticator()
        fakeAuthenticator.token = nil
        viewModel?.authenticator = fakeAuthenticator
        
        XCTAssertFalse(viewModel!.isLoggedIn())
        fakeAuthenticator.token = "token"
        XCTAssertTrue(viewModel!.isLoggedIn())
    }
}
