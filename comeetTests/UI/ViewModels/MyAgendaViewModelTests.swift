//
//  MyAgendaViewModelTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/30/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class MyAgendaViewModelTests: XCTestCase {
    
    var viewModel: MyAgendaViewModel?
    var authenticator = FakeAuthenticator()
    var persistor = FakePersistor()
    var fetcher = FakeFetcher()
    var selectedDate = Date()
    
    override func setUp() {
        super.setUp()
        viewModel = MyAgendaViewModel(authenticator: authenticator, fetcher: fetcher, persistor: persistor, selectedDate: selectedDate)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testChangeDate() {
        XCTAssertEqual(viewModel!.selectedDate, selectedDate)
        let newDate = Date().startOfDay()
        viewModel?.change(date: newDate)
        XCTAssertEqual(viewModel!.selectedDate, newDate)
    }
    
    func testMeetingsCount() {
        XCTAssertTrue(viewModel!.meetingsCount(section: 0) == 0)
        test(meetings: [Stubs.meeting()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.meetingsCount(section: 0) == 1)
        }
    }
    
    func testSectionsCount() {
        XCTAssertTrue(viewModel!.sectionsCount() == 0)
        self.fetcher.meetings = [Stubs.meeting()]
        test(meetings: [Stubs.meeting()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.sectionsCount() == 1)
        }
    }

    func testSelectedSection() {
        XCTAssertTrue(viewModel!.selectedSection() == nil)
        self.fetcher.meetings = [Stubs.meeting()]
        test(meetings: [Stubs.meeting()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.selectedSection() == 0)
        }
    }
    
    func testSectionTitle() {
        XCTAssertTrue(viewModel!.sectionTitle(section: 0) == nil)
        self.fetcher.meetings = [Stubs.meeting()]
        test(meetings: [Stubs.meeting()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.sectionTitle(section: 0) == Stubs.meeting().start.displayStringDate())
        }
    }
    
    func testMeetingSubject() {
        XCTAssertTrue(viewModel!.meetingSubject(section: 0, index: 0) == "")
        self.fetcher.meetings = [Stubs.meeting()]
        test(meetings: [Stubs.meeting()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.meetingSubject(section: 0, index: 0) == Stubs.meeting().subject)
        }
    }
    
    func testMeetingTime() {
        XCTAssertTrue(viewModel!.meetingTime(section: 0, index: 0) == "")
        self.fetcher.meetings = [Stubs.meeting()]
        test(meetings: [Stubs.meeting()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.meetingTime(section: 0, index: 0) == "\(Stubs.meeting().start.displayStringHourMinute()) - \(Stubs.meeting().end.displayStringHourMinute())")
        }
    }
    
    func testMeeting() {
        XCTAssertTrue(viewModel!.meeting(section: 0, index: 0) == nil)
        self.fetcher.meetings = [Stubs.meeting()]
        test(meetings: [Stubs.meeting()], description: "") { [weak self] in
            XCTAssertTrue(self!.viewModel!.meeting(section: 0, index: 0)! == Stubs.meeting())
        }
    }
}

private extension MyAgendaViewModelTests {
    
    func test(meetings: [Meeting], description: String, completion: @escaping ()-> Void) {
        fetcher.meetings = meetings
        
        let expect = expectation(description: description)
        viewModel?.reloadBinding = {
            completion()
            expect.fulfill()
        }
        self.viewModel?.fetchMeetings()
        waitForExpectations(timeout: 0.3, handler: nil)
    }
}
