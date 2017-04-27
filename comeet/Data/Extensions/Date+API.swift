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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-SSSS"
        return formatter.date(from: stringDate)
    }
    
    static func fromAPIFreeBusy(stringDate: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.date(from: stringDate)
    }
    
    static func fromAPIMeetings(stringDate: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: stringDate)
    }
    
    func stringForAPI() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-SSSS"
        return formatter.string(from: self)
    }
    
    func stringForAPIRooms() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
    
    func displayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH':'mm' 'MM'/'dd'/'yyyy"
        return formatter.string(from: self)
    }
    
    func displayStringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM'/'dd'/'yyyy"
        return formatter.string(from: self)
    }
    
    func displayStringHourMinute() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH':'mm"
        return formatter.string(from: self)
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func endOfDay() -> Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay())
    }
}

