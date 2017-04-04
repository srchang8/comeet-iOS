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
        static let metroareaKey = "metro"
        static let roomsListsKey = "roomlists"
    }
    
    static func parseSearchCriterion(searchCriterionDict: [AnyHashable : Any]) -> SearchCriteria? {
        guard let metroarea = searchCriterionDict[Constants.metroareaKey] as? String,
            let roomsListsArray = searchCriterionDict[Constants.roomsListsKey] as? [AnyHashable : Any] else {
                return nil
        }
        let roomsLists = RoomListParser.parseRoomLists(roomListsDict: roomsListsArray)
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
