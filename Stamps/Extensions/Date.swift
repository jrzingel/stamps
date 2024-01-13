//
//  Date+Readable.swift
//  Outline
//
//  Created by James Zingel on 18/12/23.
//

import Foundation

extension Date {
    
    // MARK: Readable date
    static var currentTimezone = TimeZone.autoupdatingCurrent
    static var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .none
        return f
    }
    
    static var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .long
        return f
    }
    
    var time: String {
        return Date.timeFormatter.string(from: self)
    }
    
    var date: String {
        return Date.dateFormatter.string(from: self)
    }
    
    // MARK: Dynamic times
    var aWeekAgo: Date {
        return self.addingTimeInterval(TimeInterval(-604_800))
    }
    
    var aMonthAgo: Date {
        // Assume a year is 365.25 days and all 12 months are equal
        return self.addingTimeInterval(TimeInterval(-2_629_800))
    }
}
