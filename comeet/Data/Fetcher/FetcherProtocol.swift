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
    func set(accessToken: String)
    func getRooms(organization: String, completion:@escaping FetchRoomsCompletion)
    func getSearchCriteria(organization: String, completion:@escaping FetchSearchCriteriaCompletion)
}
