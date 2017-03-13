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
    // Used mocked environment as default
    private var endpoints = Endpoints(environment: .Mocked)
    
    func set(environment: Environment) {
        endpoints = Endpoints(environment: environment)
    }
    
    func set(accessToken: String) {
        sessionManager.adapter = AlamofireAccessTokenAdapter(accessToken: accessToken)
    }
    
    func getRooms(completion:@escaping FetchRoomsCompletion) {
        sessionManager.request(endpoints.getRooms()).responseJSON { (response) in
            
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
}
