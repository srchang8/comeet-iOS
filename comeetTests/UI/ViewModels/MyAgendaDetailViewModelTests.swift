//
//  MyAgendaDetailViewModelTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/30/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class MyAgendaDetailViewModelTests: XCTestCase {
    
    var viewModel: MyAgendaDetailViewModel?
    var authenticator = FakeAuthenticator()
    var persistor = FakePersistor()
    var fetcher = FakeFetcher()
    
    override func setUp() {
        super.setUp()
        viewModel = MyAgendaDetailViewModel(authenticator: authenticator, fetcher: fetcher, persistor: persistor, selectedDate: Date(), selectedMeeting: Stubs.meeting())
        viewModel?.testing = true
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchMeetingData() {
        XCTAssertNil(viewModel!.selectedMeetingData)
        test(description: "") { [weak self] in
            XCTAssertNotNil(self!.viewModel!.selectedMeetingData)
        }
    }
    
    func testTitleText() {
        XCTAssertEqual(viewModel!.titleText(), "")
        test(description: "") { [weak self] in
            XCTAssertEqual(self!.viewModel!.titleText(), "\(Stubs.meeting().subject) in \(Stubs.meeting().room!.name)")
        }
    }
    
    func testTimeText() {
        XCTAssertEqual(viewModel!.timeText(), "")
        test(description: "") { [weak self] in
            XCTAssertEqual(self!.viewModel!.timeText(), "\(Stubs.meeting().start.displayStringDate()) \(Stubs.meeting().start.displayStringHourMinute()) - \(Stubs.meeting().end.displayStringHourMinute())")
        }
    }
    
    func testDetailText() {
        XCTAssertEqual(viewModel!.detailText(), "")
        test(description: "") { [weak self] in
            XCTAssertEqual(self!.viewModel!.detailText(), Stubs.meeting().body)
        }
    }
    
    func testAttendeesText() {
        XCTAssertEqual(viewModel!.attendeesText(), "  \(MyAgendaDetailViewModel.Constants.attendeesText)")
        test(description: "") { [weak self] in
            XCTAssertEqual(self!.viewModel!.attendeesText(), "  \(MyAgendaDetailViewModel.Constants.attendeesText)" + "\n  \(Stubs.meeting().requiredattendees![0].name)")
        }
    }
    
    func testRoomPicture() {
        XCTAssertNil(viewModel!.roomPicture())
        test(description: "") { [weak self] in
            XCTAssertEqual(self!.viewModel!.roomPicture(), URL(string: Stubs.meeting().room!.picture!))
        }
    }
    
    func testRoomFloorPlan() {
        XCTAssertNil(viewModel!.roomFloorPlan())
        test(description: "") { [weak self] in
            XCTAssertEqual(self!.viewModel!.roomFloorPlan(), URL(string: Stubs.meeting().room!.navigation!))
        }
    }
    
    func testRoomName() {
        XCTAssertNil(viewModel!.roomName())
        test(description: "") { [weak self] in
            XCTAssertEqual(self!.viewModel!.roomName(), Stubs.meeting().room!.name)
        }
    }
    
    func testRoomLatLong() {
        XCTAssertNil(viewModel!.roomLatLong())
        test(description: "") { [weak self] in
            XCTAssert(self!.viewModel!.roomLatLong()! == (Stubs.meeting().room!.latitude!, Stubs.meeting().room!.longitude!))
        }
    }
}

private extension MyAgendaDetailViewModelTests {
    
    func test(description: String, completion: @escaping ()-> Void) {
        fetcher.meeting = viewModel?.selectedMeeting
        
        let expect = expectation(description: description)
        viewModel?.reloadBinding = {
            completion()
            expect.fulfill()
        }
        self.viewModel?.fetchMeetingData()
        waitForExpectations(timeout: 0.3, handler: nil)
    }
}
