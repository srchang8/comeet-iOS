//
//  SearchCriteriaParserTests.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import XCTest
@testable import comeet

class SearchCriteriaParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInvalidSearchCriteria() {
        let invalidSearchCriterionDict = ["invalid": "none"]
        let searchCriteria = SearchCriteriaParser.parseSearchCriterion(searchCriterionDict: invalidSearchCriterionDict)
        
        XCTAssert(searchCriteria == nil)
    }
    
    func testInvalidSearchRoomLists() {
        let invalidSearchCriterionDict = [SearchCriteriaParser.Constants.metroareaKey: "A place",
                                          SearchCriteriaParser.Constants.roomsListsKey: "Invalid"]
        let searchCriteria = SearchCriteriaParser.parseSearchCriterion(searchCriterionDict: invalidSearchCriterionDict)
        
        XCTAssert(searchCriteria == nil)
    }
    
    func testValidSearchCriteria() {
        let invalidSearchCriterionDict: [AnyHashable : Any] = [SearchCriteriaParser.Constants.metroareaKey: "A place",
                                          SearchCriteriaParser.Constants.roomsListsKey: ["A building"]]
        let searchCriteria = SearchCriteriaParser.parseSearchCriterion(searchCriterionDict: invalidSearchCriterionDict)
        
        XCTAssert(searchCriteria != nil)
    }
}
