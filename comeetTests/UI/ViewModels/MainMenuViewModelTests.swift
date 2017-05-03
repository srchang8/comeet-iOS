//
//  MainMenuViewModelTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/30/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class MainMenuViewModelTests: XCTestCase {
    
    var viewModel: MainMenuViewModel?
    var authenticator = FakeAuthenticator()
    var persistor = FakePersistor()
    var fetcher = FakeFetcher()
    
    override func setUp() {
        super.setUp()
        viewModel = MainMenuViewModel(authenticator: authenticator, fetcher: fetcher, persistor: persistor)
    }
    
    
    func testTitle() {
        XCTAssertEqual(viewModel!.title(), "")
    }
    
    func testLogout() {
        persistor.save(metroArea: "metro")
        persistor.save(roomlist: Stubs.user())
        XCTAssertNotNil(persistor.getMetroArea())
        XCTAssertNotNil(persistor.getRoomlist())
        
        viewModel?.logout()
        XCTAssertNil(persistor.getMetroArea())
        XCTAssertNil(persistor.getRoomlist())
    }
}
