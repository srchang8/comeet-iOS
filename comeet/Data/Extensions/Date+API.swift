//
//  Date+API.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

extension Date {
    
    static func fromAPI(stringDate: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'"
        return formatter.date(from: stringDate)
    }
    
    func displayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH':'mm' 'MM'/'dd'/'yyyy"
        return formatter.string(from: self)
    }
}

