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
    }
    
    let status: String
    let start: Date
    let end: Date
    
    func isFree(start: Date, end: Date) -> Bool {
        return self.status == FreebusyBlock.Constants.freeStatus &&
            self.start <= start &&
            self.end >= end
    }
}

extension Array where Element: FreebusyProtocol {
    func containsFree(start: Date, end: Date) -> Bool {
        return self.reduce(false) { $0 || $1.isFree(start: start, end: end) }
    }
}
