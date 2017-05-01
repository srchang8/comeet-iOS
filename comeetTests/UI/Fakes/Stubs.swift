//
//  Stubs.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/19/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
@testable import comeet

struct Stubs {
    
    static func unauthorizedError() -> NSError {
        let userInfo: [AnyHashable : Any] =
            [NSLocalizedDescriptionKey: NSLocalizedString("Unauthorized", value: "Error getting token", comment: "") ,
             NSLocalizedFailureReasonErrorKey: NSLocalizedString("Unauthorized", value: "No token found", comment: "")]
        let fakeError = NSError(domain: "HttpResponseErrorDomain", code: 401, userInfo: userInfo)
        
        return fakeError
    }
    
    static func token() -> String {
        return "123"
    }
    
    static func room() -> Room {
        let room = Room(name: "Stubbed Room",
                        email: "stub@test.com",
                        address: "Fake address",
                        country: nil,
                        state: nil,
                        metroarea: "Austin",
                        latitude: 1.000,
                        longitude: 1.000,
                        capacity: 10,
                        picture: "http://fake.com",
                        navigation: "http://fake.com",
                        amenities: [Amenity(name: "An ameanity", description: "Fake Description")],
                        freebusy: nil)
        
        return room
    }
    
    static func user() -> User {
        return User(name: "Username", email: "user@fake.com")
    }
    
    static func roomDict() -> [AnyHashable : Any] {
        return [RoomParser.Constants.nameKey : "Name",
                RoomParser.Constants.emailKey : "Email"]
    }
    
    static func meeting() -> Meeting {
        let meeting = Meeting(id: "01",
                              subject: "A fake meeting",
                              body: "A very fake meeting",
                              start: Date().startOfDay(),
                              end: Date(),
                              location: nil,
                              room: Stubs.room(),
                              meetingcreator: Stubs.user(),
                              requiredattendees: [Stubs.user()],
                              optionalattendees: nil)
        return meeting
    }
    
    static func searchCriteria() -> SearchCriteria {
        let searchCriteria = SearchCriteria(metroarea: "metro", roomsLists: [user()])
        return searchCriteria
    }
}
