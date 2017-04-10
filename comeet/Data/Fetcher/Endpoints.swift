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
        // TODO: Go back to send dates once changes from the API coem through
        //return environment.rawValue + "/" + organization + "/roomlists/" + roomlist + "/rooms?start=" + start + "&end=" + end
        return environment.rawValue + "/" + organization + "/roomlists/" + roomlist + "/rooms"
    }
    
    func bookRoom(organization: String, roomrecipient: String) -> String {
        return environment.rawValue + "/" + organization + "/rooms/" + roomrecipient + "/reserve"
    }
    
    func getMeetings(organization: String, user: String, start: String, end: String) -> String {
        return environment.rawValue + "/" + organization + "/meetings?start=" + start + "&end=" + end
    }
}
