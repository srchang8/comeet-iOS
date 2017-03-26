//
//  FakeFetcher.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/19/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
@testable import comeet

class FakeFetcher: FetcherProtocol {
    
    var environment: Environment = .Production
    var accessToken: String?
    var rooms: [Room]?
    var searchCriteria: [SearchCriteria]?
    var error: Error?
    
    func set(environment: Environment) {
        self.environment = environment
    }
    
    func set(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func getRooms(organization: String,completion:@escaping FetchRoomsCompletion) {
        completion(rooms, error)
    }
    
    func getSearchCriteria(organization: String, completion:@escaping FetchSearchCriteriaCompletion) {
        completion(searchCriteria, error)
    }
}
