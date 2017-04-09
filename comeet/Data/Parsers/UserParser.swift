//
//  UserParser.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/2/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class UserParser {
    
    static func parseUsersFlat(roomListsDict: [AnyHashable : Any]) -> [User] {
        let roomLists: [User?] =  roomListsDict.keys.map { (key) -> User? in
            guard let email = key as? String,
                let name = roomListsDict[key] as? String else {
                return nil
            }
            return User(name: name, email: email)
        }
        return roomLists.filter { $0 != nil }.map { $0! }
    }
}
