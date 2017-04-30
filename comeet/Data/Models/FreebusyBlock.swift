//
//  FreebusyBlock.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

protocol FreebusyProtocol {
    func isFree(start: Date, end: Date) -> Bool
}

struct FreebusyBlock : FreebusyProtocol {

    internal struct Constants {
        static let freeStatus = "free"
        static let busyStatus = "busy"
        static let tentativeStatus = "tentative"
        static let consideredBusyStatus = [busyStatus, tentativeStatus]
    }
    
    let status: String
    let start: Date
    let end: Date
    
    func isFree(start: Date, end: Date) -> Bool {
        guard Constants.consideredBusyStatus.contains(self.status.lowercased()) else  {
            return true
        }
        let busyBefore = end >= self.start && end <= self.end
        let busyAfter = start >= self.start && start <= self.end
        let busyThroughout = start < self.start && end > self.end
        let isFree = !busyBefore && !busyAfter && !busyThroughout
        return isFree
    }
}

extension Array where Element: FreebusyProtocol {
    func isFree(start: Date, end: Date) -> Bool {
        
        var isFree = true
        for busyBlock in self {
            isFree = busyBlock.isFree(start: start, end: end)
        }
        return isFree
    }
}
