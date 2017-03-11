//
//  Room.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/11/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class Room {
    
    static func parseRoom(roomDict: NSDictionary) -> Room {
        return Room()
    }
    
    static func parseRooms(roomsArray: NSArray) -> [Room] {
        var rooms:[Room] = []
        for roomDict in roomsArray {
            if let roomDict = roomDict as? NSDictionary {
                let room = parseRoom(roomDict: roomDict)
                rooms.append(room)
            }
        }
        return rooms
    }
}
