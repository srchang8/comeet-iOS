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
                        latitude: nil,
                        longitude: nil,
                        capacity: 10)
        
        return room
    }
}
