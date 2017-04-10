//
//  UserParser.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/2/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class UserParser {
    
    internal struct Constants {
        static let nameKey = "name"
        static let emailKey = "email"
    }
    
    static func parseUser(userDict: [AnyHashable : Any]) -> User? {
        guard let name = userDict[Constants.nameKey] as? String,
            let email = userDict[Constants.emailKey] as? String else {
                return nil
        }
        return User(name: name, email: email)
    }
    
    static func parseUsers(usersArray: [Any]) -> [User] {
        var users: [User]  = []
        for userDict in usersArray {
            if let userDict = userDict as? [AnyHashable : Any] {
                if let user = parseUser(userDict: userDict) {
                    users.append(user)
                }
            }
        }
        return users
    }
    
    static func parseUsersFlat(usersDict: [AnyHashable : Any]) -> [User] {
        let users: [User?] =  usersDict.keys.map { (key) -> User? in
            guard let email = key as? String,
                let name = usersDict[key] as? String else {
                return nil
            }
            return User(name: name, email: email)
        }
        return users.filter { $0 != nil }.map { $0! }
    }
}
