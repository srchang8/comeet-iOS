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
    var authType: AuthType?
    var rooms: [Room]?
    var searchCriteria: [SearchCriteria]?
    var error: Error?
    
    func set(environment: Environment) {
        self.environment = environment
    }
    
    func set(accessToken: String, type: AuthType) {
        self.accessToken = accessToken
        self.authType = type
    }
    
    func getSearchCriteria(organization: String, completion:@escaping FetchSearchCriteriaCompletion) {
        completion(searchCriteria, error)
    }
    
    func getRooms(organization: String, roomlist: String, completion:@escaping FetchRoomsCompletion) {
        completion(rooms, error)
    }
}
