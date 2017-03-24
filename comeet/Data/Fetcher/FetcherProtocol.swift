//
//  FetcherProtocol.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/11/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

typealias FetchRoomsCompletion = ([Room]?, Error?)-> Void

protocol FetcherProtocol {
    func set(environment: Environment)
    func set(accessToken: String)
    func getRooms(completion:@escaping FetchRoomsCompletion)
}