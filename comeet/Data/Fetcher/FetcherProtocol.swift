//
//  FetcherProtocol.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/11/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

typealias FetchRoomsCompletion = ([Room]?, Error?)-> Void
typealias FetchMeetingsCompletion = ([Meeting]?, Error?)-> Void
typealias FetchSearchCriteriaCompletion = ([SearchCriteria]?, Error?)-> Void
typealias BookRoomCompletion = (Bool, Error?)-> Void

protocol FetcherProtocol {
    func set(environment: Environment)
    func set(accessToken: String, type: AuthType)
    func getSearchCriteria(organization: String, completion:@escaping FetchSearchCriteriaCompletion)
    func getRooms(organization: String, roomlist: String, start: String, end: String, completion:@escaping FetchRoomsCompletion)
    func bookRoom(organization: String, roomrecipient: String, params: [String: Any], completion:@escaping BookRoomCompletion)
    func bookRoomParams(start: String, end: String, subject: String, body: String, requiredAttendees: [String], optionalAttendees:[String]?) -> [String: Any]
    func getMeetings(organization: String, user: String, start: String, end: String, completion:@escaping FetchMeetingsCompletion)
}
