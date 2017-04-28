//
//  RoomsListViewModelTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/19/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class RoomsListViewModelTests: XCTestCase {
    
    var viewModel: RoomsListViewModel?
    var authenticator: FakeAuthenticator?
    var persistor = PersistorUserDefaultsImplementer()
    var fetcher: FakeFetcher?
    
    override func setUp() {
        super.setUp()
        authenticator = FakeAuthenticator()
        fetcher = FakeFetcher()
        let roomlist = User(name: "A Building", email: "test@test.com")
        viewModel = RoomsListViewModel(authenticator: authenticator!, fetcher: fetcher!, persistor: persistor,selectedDate: Date(), metroarea: "A City", roomsList: roomlist)
        viewModel?.testing = true
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchRooms() {
        self.fetcher?.rooms = [Stubs.room()]
        test(rooms: [Stubs.room()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.roomsCount() == 1)
        }
    }
    
    func testRoomName() {
        XCTAssertTrue(viewModel?.roomName(index: 0) == "")
        test(rooms: [Stubs.room()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.roomName(index: 0) == Stubs.room().name)
        }
    }
    
    func testRoomDescription() {
        XCTAssertTrue(viewModel?.roomDescription(index: 0) == "")
        test(rooms: [Stubs.room()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.roomDescription(index: 0) ==
                "Capacity: " + "\(Stubs.room().capacity!)" )
        }
    }
    
    func testRoomLatLong() {
        XCTAssertTrue(viewModel?.roomLatLong(index: 0) == nil)
        test(rooms: [Stubs.room()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.roomLatLong(index: 0)! ==
                (Stubs.room().latitude!, Stubs.room().longitude!) )
        }
    }
    
    func testRoomPicture() {
        XCTAssertTrue(viewModel?.roomLatLong(index: 0) == nil)
        test(rooms: [Stubs.room()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.roomPicture(index: 0)! == URL(string: Stubs.room().picture!))
        }
    }
    
    func testRoomFloorPlan() {
        XCTAssertTrue(viewModel?.roomLatLong(index: 0) == nil)
        test(rooms: [Stubs.room()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.roomFloorPlan(index: 0)! == URL(string: Stubs.room().navigation!))
        }
    }
    
    func testTitle() {
        XCTAssertEqual(self.viewModel?.title(), RoomsListViewModel.Constants.titleText + "A Building")
        viewModel?.newLocation(metroarea: nil, roomsList: nil)
        XCTAssertEqual(self.viewModel?.title(), RoomsListViewModel.Constants.genericTitleText)
    }
    
    func testChangeDate() {
        let date = Date()
        viewModel?.change(date: date)
        XCTAssertEqual(date, viewModel?.selectedDate)
    }
}

private extension RoomsListViewModelTests {

    func test(rooms: [Room], description: String, completion: @escaping ()-> Void) {
        fetcher?.rooms = rooms
        
        let expect = expectation(description: description)
        viewModel?.reloadBinding = {
            completion()
            expect.fulfill()
        }
        self.viewModel?.fetchRooms()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
