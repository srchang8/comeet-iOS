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
    var bookRoomParams: [String: Any] = [:]
    var meetings: [Meeting] = []
    
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
    
    func getRooms(organization: String, roomlist: String, start: String, end: String, completion:@escaping FetchRoomsCompletion) {
    }
    
    func bookRoom(organization: String, roomrecipient: String, params: [String: Any], completion:@escaping BookRoomCompletion) {
        
    }
    
    func bookRoomParams(start: String, end: String, subject: String, body: String, requiredAttendees: String) -> [String: Any] {
        return bookRoomParams
    }
    
    func getMeetings(organization: String, user: String, start: String, end: String, completion:@escaping FetchMeetingsCompletion) {
    }
    
    func getMeetingData(organization: String, id: String, completion:@escaping FetchMeetingCompletion) {
        
    }
}
