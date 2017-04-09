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
        return environment.rawValue + "/" + organization + "/metros"
    }
    
    func getRooms(organization: String, roomlist: String, start: String, end: String) -> String {
        return environment.rawValue + "/" + organization + "/roomlists/" + roomlist + "/rooms?start=" + start + "&end=" + end
    }
    
    func bookRoom(organization: String, roomrecipient: String) -> String {
        return environment.rawValue + "/" + organization + "/rooms/" + roomrecipient + "/reserve"
    }
    
    func getMeetings(organization: String, user: String, start: String, end: String) -> String {
        return environment.rawValue + "/" + organization + "/users/" + user + "meetings?start=" + start + "&end=" + end
    }
}
