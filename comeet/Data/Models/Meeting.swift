//
//  Meeting.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/11/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

struct Meeting : Equatable {

    let id: String
    let subject: String
    let body: String
    let start: Date
    let end: Date
    let location: String?
    let room: Room?
    let meetingcreator: User?
    let requiredattendees: [User]?
    let optionalattendees: [User]?
    
    public static func ==(lhs: Meeting, rhs: Meeting) -> Bool {
        return lhs.id == rhs.id && lhs.subject == rhs.subject
    }
}
