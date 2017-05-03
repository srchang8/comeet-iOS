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
        guard let status = freebusyBlockDict[Constants.statusKey] as? String,
            let startString = freebusyBlockDict[Constants.startKey] as? String,
            let endString = freebusyBlockDict[Constants.endKey] as? String else {
                return nil
        }

        guard let start = Date.fromISO8601(string: startString),
            let end = Date.fromISO8601(string: endString),
            start < end else {
                return nil
        }
        
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
}
