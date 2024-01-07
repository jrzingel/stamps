//
//  Item.swift
//  Stamps
//
//  Created by James Zingel on 7/01/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
