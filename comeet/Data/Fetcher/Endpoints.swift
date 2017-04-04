//
//  Endpoints.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/12/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

struct Endpoints {
    
    let environment: Environment
    
    func getSeatchCriteria(organization: String) -> String {
        let seatchCriteriaPath = environment.rawValue + "/" + organization + "/metros"
        return seatchCriteriaPath
    }
    
    func getRooms(organization: String, roomlist: String) -> String {
        let validRoomList: String = roomlist.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let roomsPath = environment.rawValue + "/" + organization + "/roomlists/" + validRoomList + "/rooms"
        
        return roomsPath
    }
}
