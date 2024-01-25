//
//  Log.swift
//  Outline
//
//  Created by James on 9/12/23.
//

import SwiftUI
import CoreLocation
import SwiftData

// Log objects

/// Time stamp as UNIX (UTC) from 1970. Seconds only.
public typealias UnixTime = Int

/// A raw structure of a log. These objects are parsed by the API
struct RawStamp: Decodable {
    var time: UnixTime
    var coords: [Coord]
    var suburb: String
    var device: String
    var category: Category
    var title: String
    var desc: String
}

/// A functional log object with many computed properties
@Model
class Stamp: Identifiable {
    var id: String = UUID().uuidString
    var lastUpdated: Date   // Last time data was modified
    var lastSynced: Date?   // Time synced with the API server
    
    @Attribute(.unique) var time: Date      // Force only one log at a time
    var coords: [Coord]
    var suburb: String  // Localised version of coords[0]
    var device: String
    var category: Category
    var title: String
    var desc: String
    
    
    /// Convert from a `RawLog` to `Log`. Usually when syncing from the API
    init(from rawStamp: RawStamp, lastSynced: Date? = nil) {
        self.device = rawStamp.device
        self.time = Date(timeIntervalSince1970: Double(rawStamp.time))
        self.coords = rawStamp.coords
        self.suburb = rawStamp.suburb
        self.category = rawStamp.category
        self.title = rawStamp.title
        self.desc = rawStamp.desc
        self.lastSynced = lastSynced
        self.lastUpdated = Date()
    }
    
    /// Create a new stamp with a "default" configuration
    init() {
        self.device = Devices.this.description
        self.time = Date()
        self.coords = [Coord.Tauranga]
        self.suburb = ""
        self.category = .none
        self.title = ""
        self.desc = ""
        self.lastSynced = nil
        self.lastUpdated = Date()
    }
    
    
    // MARK: Helper map functions
    
    var icon: String {
        category.icon
    }
    
    var color: Color {
        category.color
    }
    
    /// If the latest version of the stamp has been synced
    var isSynced: Bool {
        if let lastSynced = lastSynced {
            return lastSynced >= lastUpdated
        }
        return false
    }
    
}
