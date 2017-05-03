//
//  FakePersistor.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/30/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
@testable import comeet

class FakePersistor : PersistorProtocol {
    
    public var metroArea: String?
    public var roomlist: User?
    
    func save(metroArea: String?) {
        self.metroArea = metroArea
    }
    
    func getMetroArea() -> String? {
        return metroArea
    }
    
    func save(roomlist: User?) {
        self.roomlist = roomlist
    }
    
    func getRoomlist() -> User? {
        return roomlist
    }
}
