//
//  SearchCriteriaParser.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class SearchCriteriaParser {
    
    internal struct Constants {
        static let metroareaKey = "metroarea"
        static let roomsListsKey = "roomslists"
    }
    
    static func parseSearchCriterion(searchCriterionDict: [AnyHashable : Any]) -> SearchCriteria? {
        guard let metroarea = searchCriterionDict[Constants.metroareaKey] as? String,
            let roomsLists = searchCriterionDict[Constants.roomsListsKey] as? [String] else {
                return nil
        }
        let searchCriterion = SearchCriteria(metroarea: metroarea, roomsLists: roomsLists)
        return searchCriterion
    }
    
    static func parseSearchCriteria(searchCriteriaArray: [Any]) -> [SearchCriteria] {
        var searchCriteria: [SearchCriteria] = []
        for searchCriterionDict in searchCriteriaArray {
            if let searchCriterionDict = searchCriterionDict as? [AnyHashable : Any] {
                if let searchCriterion = SearchCriteriaParser.parseSearchCriterion(searchCriterionDict: searchCriterionDict) {
                    searchCriteria.append(searchCriterion)
                }
            }
        }
        return searchCriteria
    }
}
