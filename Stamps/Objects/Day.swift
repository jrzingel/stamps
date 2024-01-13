//
//  Day.swift
//  Outline
//
//  Created by James Zingel on 23/12/23.
//

import Foundation

class Day: Identifiable {
    var logs: [Log]
    var day: String
    
    init(_ day: String) {
        self.day = day
        self.logs = []
    }
    
    func add(_ log: Log) {
        logs.append(log)
    }
    
    /// Reverse the log order
    func reverseLogList() {
        logs.reverse()
    }
}
