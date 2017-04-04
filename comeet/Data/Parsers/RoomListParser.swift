//
//  RoomListParser.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/2/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class RoomListParser {
    
    static func parseRoomLists(roomListsDict: [AnyHashable : Any]) -> [RoomList] {
        let roomLists: [RoomList?] =  roomListsDict.keys.map { (key) -> RoomList? in
            guard let email = key as? String,
                let name = roomListsDict[key] as? String else {
                return nil
            }
            return RoomList(name: name, email: email)
        }
        return roomLists.filter { $0 != nil }.map { $0! }
    }
}
