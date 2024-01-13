//
//  Day.swift
//  Outline
//
//  Created by James Zingel on 23/12/23.
//

import Foundation

class Day: Identifiable {
    var stamps: [Stamp]
    var day: String
    
    init(_ day: String) {
        self.day = day
        self.stamps = []
    }
    
    func add(_ log: Stamp) {
        stamps.append(log)
    }
    
    /// Reverse the log order
    func reverseLogList() {
        stamps.reverse()
    }
}
