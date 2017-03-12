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
    
    private struct Endpoints {
        static let fetchRooms = "https://private-98f9ba-comeet.apiary-mock.com/rooms"
    }
    
    
    func fetchRooms(completion:@escaping FetchRoomsCompletion) {
        Alamofire.request(Endpoints.fetchRooms).responseJSON { (response) in
            
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
