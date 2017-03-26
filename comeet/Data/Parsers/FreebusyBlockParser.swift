//
//  FreebusyBlockParser.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class FreebusyBlockParser {
    
    internal struct Constants {
        static let statusKey = "status"
        static let startKey = "start"
        static let endKey = "end"
    }
    
    static func parseFreebusyBlock(freebusyBlockDict: [AnyHashable : Any]) -> FreebusyBlock? {
        guard let status = freebusyBlockDict[Constants.startKey] as? String,
            let startString = freebusyBlockDict[Constants.startKey] as? String,
            let endString = freebusyBlockDict[Constants.endKey] as? String else {
                return nil
        }
        guard let start = fromAPI(stringDate: startString),
            let end = fromAPI(stringDate: endString),
            start < end else {
                return nil
        }
        
        // TODO: Guard for valid statuses
        
        let freebusyBlock = FreebusyBlock(status: status, start: start, end: end)
        return freebusyBlock
    }
    
    static func parseFreebusyBlocks(freebusyBlocksArray: [Any]) -> [FreebusyBlock] {
        var freebusyBlocks: [FreebusyBlock] = []
        for freebusyBlockDict in freebusyBlocksArray {
            if let freebusyBlockDict = freebusyBlockDict as? [AnyHashable : Any] {
                if let freebusyBlock = FreebusyBlockParser.parseFreebusyBlock(freebusyBlockDict: freebusyBlockDict) {
                    freebusyBlocks.append(freebusyBlock)
                }
            }
        }
        return freebusyBlocks
    }
    
    static func fromAPI(stringDate: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'"
        return formatter.date(from: stringDate)
    }
}
