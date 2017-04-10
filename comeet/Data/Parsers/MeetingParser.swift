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
        static let subjectKey = "subject"
        static let bodyKey = "body"
        static let locationKey = "location"
        static let startKey = "start"
        static let endKey = "end"
        static let roomKey = "room"
        static let metingcreatorKey = "metingcreator"
        static let requiredattendeesKey = "requiredattendees"
        static let optionalattendeesKey = "optionalattendees"
    }
    
    static func parseMeeting(meetingDict: [AnyHashable : Any]) -> Meeting? {
        guard let subject = meetingDict[Constants.subjectKey] as? String,
            let body = meetingDict[Constants.bodyKey] as? String,
            let location = meetingDict[Constants.locationKey] as? String,
            let startString = meetingDict[Constants.startKey] as? String,
            let endString = meetingDict[Constants.endKey] as? String,
            let roomDict = meetingDict[Constants.roomKey] as? [AnyHashable : Any],
            let meetingcreatorDict = meetingDict[Constants.metingcreatorKey] as? [AnyHashable : Any] else {
                return nil
        }
        
        guard let start = Date.fromAPI(stringDate: startString),
            let end = Date.fromAPI(stringDate: endString),
            start < end else {
                return nil
        }
        
        guard let room = RoomParser.parseRoom(roomDict: roomDict) else {
            return nil
        }
        
        guard let meetingcreator = UserParser.parseUser(userDict: meetingcreatorDict) else {
            return nil
        }
        
        var requiredattendees: [User] = []
        if let requiredattendeesArray = meetingDict[Constants.requiredattendeesKey] as? [Any] {
            requiredattendees = UserParser.parseUsers(usersArray: requiredattendeesArray)
        }
        
        var optionalattendees: [User] = []
        if let optionalattendeesArray = meetingDict[Constants.optionalattendeesKey] as? [Any] {
            optionalattendees = UserParser.parseUsers(usersArray: optionalattendeesArray)
        }
        
        return Meeting(subject: subject, body: body, start: start, end: end, location: location, room: room, metingcreator: meetingcreator, requiredattendees: requiredattendees, optionalattendees: optionalattendees)
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
