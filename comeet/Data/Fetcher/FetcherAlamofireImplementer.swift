//
//  FetcherAlamofireImplementer.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/11/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import Alamofire

class FetcherAlamofireImplementer : FetcherProtocol {
    
    private let sessionManager = SessionManager()
    private var endpoints = Endpoints(environment: .Mocked)
    
    func set(environment: Environment) {
        endpoints = Endpoints(environment: environment)
    }
    
    func set(accessToken: String) {
        sessionManager.adapter = AlamofireAccessTokenAdapter(accessToken: accessToken)
    }
    
    func getRooms(organization: String,completion:@escaping FetchRoomsCompletion) {
        sessionManager.request(endpoints.getRooms(organization: organization)).responseJSON { [weak self] (response) in
            self?.handleRooms(completion: completion, response: response)
        }
    }
}

private extension FetcherAlamofireImplementer {
    func handleRooms(completion:@escaping FetchRoomsCompletion, response: DataResponse<Any>) {
        guard response.error == nil else {
            completion(nil, response.error)
            return;
        }
        
        if let JSON = response.result.value {
            if let roomsArray = JSON as? NSArray {
                let rooms = RoomParser.parseRooms(roomsArray: roomsArray)
                completion(rooms, nil)
            } else {
                completion(nil, nil)
            }
        } else {
            completion(nil, nil)
        }
    }
}
