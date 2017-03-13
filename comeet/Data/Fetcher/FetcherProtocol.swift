//
//  FetcherProtocol.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/11/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

typealias FetchRoomsCompletion = ([Room]?, Error?)-> Void

enum Environment : String {
    case Mocked = "https://private-98f9ba-comeet.apiary-mock.com"
    case Stage = "http://ec2-52-35-139-201.us-west-2.compute.amazonaws.com:8080/JavaApplication/rest/UserService"
    case Production = ""
}

protocol FetcherProtocol {
    func set(environment: Environment)
    func set(accessToken: String)
    func getRooms(completion:@escaping FetchRoomsCompletion)
}
