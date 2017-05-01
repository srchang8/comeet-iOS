//
//  RoomDetailViewModelTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/30/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class RoomDetailViewModelTests: XCTestCase {
    
    var viewModel: RoomDetailViewModel?
    var authenticator = FakeAuthenticator()
    var persistor = FakePersistor()
    var fetcher = FakeFetcher()
    var selectedDate = Date()
    
    override func setUp() {
        super.setUp()
        
        viewModel = RoomDetailViewModel(authenticator: authenticator, fetcher: fetcher, startDate: selectedDate.startOfDay(), endDate: selectedDate, metroarea: Stubs.searchCriteria().metroarea, roomsList: Stubs.searchCriteria().roomsLists[0], room: Stubs.room())
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBookRoomFail() {
        let expect = expectation(description: description)
        viewModel?.bookRoomBinding = { (success: Bool) in
            XCTAssertFalse(success)
            expect.fulfill()
        }
        self.viewModel?.bookRoom(subject: "Test subject", body: "Test body")
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testBookRoomSuccess() {
        fetcher.bookSuccess = true
        let expect = expectation(description: description)
        viewModel?.bookRoomBinding = { (success: Bool) in
            XCTAssert(success)
            expect.fulfill()
        }
        self.viewModel?.bookRoom(subject: "Test subject", body: "Test body")
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testRoomAddress() {
        XCTAssertEqual(viewModel!.roomname(), Stubs.room().name)
    }
    
    func testRoomname() {
        XCTAssertEqual(viewModel!.roomAddress(), Stubs.searchCriteria().metroarea + "\n" + Stubs.room().address!)
    }
    
    func testRoomPicture() {
        XCTAssertEqual(viewModel!.roomPicture(), URL(string: Stubs.room().picture!))
    }
    
    func testRoomBookText() {
        XCTAssertEqual(viewModel!.roomBookText(), "Book \(selectedDate.startOfDay().displayStringDate()) \(selectedDate.startOfDay().displayStringHourMinute())-\(selectedDate.displayStringHourMinute())")
    }
}
