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
    
    func getRooms(organization: String) -> String {
        let roomsPath = environment.rawValue + "/" + organization + "/rooms"
        return roomsPath
    }
    
    func getSeatchCriteria(organization: String) -> String {
        let roomsPath = environment.rawValue + "/" + organization + "/searchcriteria"
        return roomsPath
    }
}
