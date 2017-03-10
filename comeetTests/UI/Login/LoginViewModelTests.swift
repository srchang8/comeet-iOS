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
        fakeAuthenticator.token = fakeToken()
        
        viewModel?.authenticator = fakeAuthenticator
        
        viewModel!.tokenBinding = { [weak self] (token: String) in
            XCTAssert(token == self?.fakeToken())
        }
        viewModel!.tokenErrorBinding = { (error: Error) in
            XCTAssert(false)
        }
        viewModel!.getToken()
    }
    
    func testTokenError() {
        
        let fakeAuthenticator = FakeAuthenticator()
        fakeAuthenticator.error = fakeError()
        
        viewModel?.authenticator = fakeAuthenticator
        
        viewModel!.tokenBinding = { (token: String) in
            XCTAssert(false)
        }
        viewModel!.tokenErrorBinding = { [weak self] (error: Error) in
            XCTAssert(error.localizedDescription == self?.fakeError().localizedDescription)
        }
        viewModel!.getToken()
    }
}

class FakeAuthenticator: AuthenticatorProtocol
{
    public var token: String?
    public var error: Error?
    
    func getToken(completion:@escaping TokenCompletion) {
        completion(token, error)
    }
}

private extension LoginViewModelTests {
    func fakeError() -> NSError {
        let userInfo: [AnyHashable : Any] =
            [NSLocalizedDescriptionKey: NSLocalizedString("Unauthorized", value: "Error getting token", comment: "") ,
             NSLocalizedFailureReasonErrorKey: NSLocalizedString("Unauthorized", value: "No token found", comment: "")]
        let fakeError = NSError(domain: "HttpResponseErrorDomain", code: 401, userInfo: userInfo)
        
        return fakeError
    }
    
    func fakeToken() -> String {
        return "123"
    }
}
