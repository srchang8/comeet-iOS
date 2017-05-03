//
//  MeetingParser.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/9/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class MeetingParser {
    
    internal struct Constants {
        static let idKey = "id"
        static let subjectKey = "subject"
        static let bodyKey = "body"
        static let locationKey = "location"
        static let startKey = "start"
        static let endKey = "end"
        static let roomKey = "room"
        static let metingcreatorKey = "meetingcreator"
        static let requiredattendeesKey = "requiredattendees"
        static let optionalattendeesKey = "optionalattendees"
    }
    
    static func parseMeeting(meetingDict: [AnyHashable : Any]) -> Meeting? {
        
        guard let subject = meetingDict[Constants.subjectKey] as? String,
            let body = meetingDict[Constants.bodyKey] as? String,
            let startString = meetingDict[Constants.startKey] as? String,
            let endString = meetingDict[Constants.endKey] as? String,
            let id = meetingDict[Constants.idKey] as? String else {
                return nil
        }
            
        
        var location: String?
        if let locationValue = meetingDict[Constants.locationKey] as? String {
            location = locationValue
        }

        guard let start = Date.fromISO8601(string: startString),
            let end = Date.fromISO8601(string: endString) else {
                return nil
        }
        
        var room: Room? = nil
        if let roomDict = meetingDict[Constants.roomKey] as? [AnyHashable : Any] {
            room = RoomParser.parseRoom(roomDict: roomDict)
        }
        
        var meetingcreator: User? = nil
        if let meetingcreatorDict = meetingDict[Constants.metingcreatorKey] as? [AnyHashable : Any] {
            meetingcreator = UserParser.parseUser(userDict: meetingcreatorDict)
        }
        
        var requiredattendees: [User] = []
        if let requiredattendeesArray = meetingDict[Constants.requiredattendeesKey] as? [Any] {
            requiredattendees = UserParser.parseUsers(usersArray: requiredattendeesArray)
        }
        
        var optionalattendees: [User] = []
        if let optionalattendeesArray = meetingDict[Constants.optionalattendeesKey] as? [Any] {
            optionalattendees = UserParser.parseUsers(usersArray: optionalattendeesArray)
        }
        
        
        return Meeting(id: id, subject: subject, body: body, start: start, end: end, location: location, room: room, meetingcreator: meetingcreator, requiredattendees: requiredattendees, optionalattendees: optionalattendees)
    }
    
    static func parseMeetings(meetingsArray: [Any]) -> [Meeting] {
        var meetings:[Meeting] = []
        for meetingDict in meetingsArray {
            
            if let meetingDict = meetingDict as? [AnyHashable : Any] {
                
                if let meeting = parseMeeting(meetingDict: meetingDict) {
                    
                    meetings.append(meeting)
                }
            }
        }
        return meetings
    }
}
