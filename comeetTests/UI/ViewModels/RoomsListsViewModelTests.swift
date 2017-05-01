//
//  RoomsListsViewModelTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/30/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class RoomsListsViewModelTests: XCTestCase {
    
    var viewModel: RoomsListsViewModel?
    var authenticator = FakeAuthenticator()
    var persistor = FakePersistor()
    var fetcher = FakeFetcher()
    var selectedDate = Date()
    
    override func setUp() {
        super.setUp()
        viewModel = RoomsListsViewModel(authenticator: authenticator, fetcher: fetcher, selectedDate: selectedDate, metroarea: Stubs.searchCriteria().metroarea, roomsLists: Stubs.searchCriteria().roomsLists, persistor: persistor)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTitle() {
        XCTAssertEqual(viewModel!.title(), "Locations in " + Stubs.searchCriteria().metroarea)
    }
    
    func testRoomsListsCount() {
        XCTAssert(viewModel!.roomsListsCount() == 1)
    }
    
    func testRoomsListName() {
        XCTAssert(viewModel!.roomsListName(index: 0) == Stubs.searchCriteria().roomsLists[0].name)
    }
    
    func testRoomsList() {
        XCTAssert(viewModel!.roomsList(index: 0) == Stubs.searchCriteria().roomsLists[0])
    }
    
    func testGetMetroArea() {
        XCTAssertEqual(viewModel!.getMetroarea(), Stubs.searchCriteria().metroarea)
    }
    
    func testSaveRoomlist() {
        XCTAssertNil(persistor.getRoomlist())
        viewModel?.save(roomlist: Stubs.user())
        XCTAssertEqual(persistor.getRoomlist(), Stubs.user())
    }
}
