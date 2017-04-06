//
//  PersistorUserDefaultsImplementer.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/4/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class PersistorUserDefaultsImplementer : PersistorProtocol {
    
    private struct Constants {
        static let metroAreaKey = "metroAreaKey"
        static let roomlistKey = "roomlistKey"
    }
    
    func save(metroArea: String?) {
        UserDefaults.standard.set(metroArea, forKey: Constants.metroAreaKey)
        UserDefaults.standard.synchronize()
    }
    
    func getMetroArea() -> String? {
        return UserDefaults.standard.string(forKey: Constants.metroAreaKey)
    }
    
    func save(roomlist: [RoomList]?) {
        UserDefaults.standard.set(roomlist, forKey: Constants.roomlistKey)
        UserDefaults.standard.synchronize()
    }
    
    func getRoomlist() -> [RoomList]? {
        if let roomlist = UserDefaults.standard.object(forKey: Constants.roomlistKey) as? [RoomList] {
            return roomlist
        } else {
            return nil
        }
    }
}
