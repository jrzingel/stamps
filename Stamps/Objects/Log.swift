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
struct RawLog: Decodable {
    var time: Int
    var longitude: String
    var latitude: String
    var suburb: String
    var device: String
    var type: String
    var log: String
}

/// A functional log object with many computed properties
@Model
class Log: Identifiable {
    var id: String = UUID().uuidString
    @Attribute(.unique) var time: Date      // Force only one log at a time
    var coord: Coord
    var suburb: String
    var device: String
    var category: Category
    var log: String
    
    /// If this log has been synced with the API server
    var uploaded: Bool
    
    /// Convert from a `RawLog` to `Log`
    init(from rawLog: RawLog, downloaded: Bool = false) {
        self.suburb = rawLog.suburb
        self.device = rawLog.device
        
        self.time = Date(timeIntervalSince1970: Double(rawLog.time))
        self.coord = Coord(longitude: rawLog.longitude, latitude: rawLog.latitude)
        
        self.category = rawLog.type.toCategory()
        self.log = rawLog.log
        self.uploaded = downloaded
    }
    
    /// Only use for debugging purposes
    convenience init(_ unixTime: UnixTime, _ longitude: Double, _ latitude: Double, _ suburb: String, _ device: String, _ rawType: String, _ log: String) {
        self.init(from: RawLog(time: unixTime, longitude: String(longitude), latitude: String(latitude), suburb: suburb, device: device, type: rawType, log: log))
    }
    
    /// Create a log with a "default" configuration
    init() {
        self.suburb = "need_to_implement"
        self.device = Devices.this.description
        self.time = Date()
        self.coord = Coord()
        self.category = .generic
        self.log = ""
        self.uploaded = false
    }
    
    
    // MARK: Helper map functions
    
    var icon: String {
        category.icon
    }
    
    var color: Color {
        category.color
    }
    
}

let SAMPLE_LOGS: [Log] = [
    Log(5625, 176.253, -37.526, "Te Puna", "iPhone", "COMMON", "sample log"),
    Log(5752, 176.253, -37.526, "Te Puna", "iPhone", "UNCOMMON", "dddd"),
    Log(5821, 176.253, -37.526, "Te Puke", "iPhone", "CODE", "morerrrr"),
    Log(6111, 176.253, -37.526, "Auckland", "iPhone", "UNI", "someothers"),
]
