//
//  FetcherProtocol.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/11/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

typealias FetchRoomsCompletion = ([Room]?, Error?)-> Void
typealias FetchSearchCriteriaCompletion = ([SearchCriteria]?, Error?)-> Void

protocol FetcherProtocol {
    func set(environment: Environment)
    func set(accessToken: String, type: AuthType)
    func getSearchCriteria(organization: String, completion:@escaping FetchSearchCriteriaCompletion)
    func getRooms(organization: String, roomlist: String, completion:@escaping FetchRoomsCompletion)
}
