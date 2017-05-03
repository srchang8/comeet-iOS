//
//  MetroareaViewModelTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/30/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class MetroareaViewModelTests: XCTestCase {
    
    var viewModel: MetroareaViewModel?
    var authenticator = FakeAuthenticator()
    var persistor = FakePersistor()
    var fetcher = FakeFetcher()
    var selectedDate = Date()
    
    override func setUp() {
        super.setUp()
        viewModel = MetroareaViewModel(authenticator: authenticator, fetcher: fetcher, selectedDate: selectedDate, persistor: persistor)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchSearchCriteria() {
        XCTAssert(viewModel!.metroareaCount() == 0)
        test(criteria: [Stubs.searchCriteria()], description: "") { [weak self] in
            XCTAssert(self!.viewModel!.metroareaCount() == 1)
        }
    }
    
    func testMetroareaCached() {
        XCTAssertEqual(viewModel!.metroareaCached(), nil)
        persistor.save(metroArea: "metro")
        XCTAssertEqual(viewModel!.metroareaCached(), "metro")
    }
    
    func testSaveMetroArea() {
        XCTAssertEqual(persistor.getMetroArea(), nil)
        viewModel?.save(metroarea: "metro")
        XCTAssertEqual(persistor.getMetroArea(), "metro")
    }
    
    func testMetroareaName() {
        XCTAssert(viewModel!.metroareaName(index: 0) == "")
        test(criteria: [Stubs.searchCriteria()], description: "") { [weak self] in
            XCTAssert(self!.viewModel!.metroareaName(index: 0) == Stubs.searchCriteria().metroarea)
        }
    }
    
    func testRoomsLists() {
        test(criteria: [Stubs.searchCriteria()], description: "") { [weak self] in
            XCTAssert(self!.viewModel!.roomsLists(index: 0) == Stubs.searchCriteria().roomsLists)
        }
    }
    
    func testRoomsListsByMetro() {
        XCTAssertNil(viewModel!.roomsLists(metroarea: Stubs.searchCriteria().metroarea))
        test(criteria: [Stubs.searchCriteria()], description: "") { [weak self] in
            XCTAssertEqual(self!.viewModel!.roomsLists(metroarea: Stubs.searchCriteria().metroarea)!, Stubs.searchCriteria().roomsLists)
        }
    }
}

private extension MetroareaViewModelTests {
    
    func test(criteria: [SearchCriteria], description: String, completion: @escaping ()-> Void) {
        fetcher.searchCriteria = criteria
        
        let expect = expectation(description: description)
        viewModel?.reloadBinding = {
            completion()
            expect.fulfill()
        }
        self.viewModel?.fetchSearchCriteria()
        waitForExpectations(timeout: 0.3, handler: nil)
    }
}
