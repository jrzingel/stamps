//
//  PreviewSampleData.swift
//  Stamps
//
//  Created by James Zingel on 25/01/24.
//

import SwiftData
import SwiftUI

extension Stamp {
    /// Only use for debugging purposes
    convenience init(_ unixTime: UnixTime, _ longitude: Double, _ latitude: Double, _ suburb: String, _ device: String, _ rawType: String, _ log: String) {
        self.init(from: RawStamp(time: unixTime, coords: [Coord(longitude: String(longitude), latitude: String(latitude))], suburb: suburb, device: device, category: rawType.toCategory(), title: log, desc: ""))
    }
    
    static var samples: [Stamp] {
        let raw = [
            RawStamp(time: 5123542, coords: [Coord.Tauranga], suburb: "City", device: "iPhone", category: .activity, title: "Run", desc: "Run in the wild"),
            RawStamp(time: 6444132, coords: [Coord.Tauranga], suburb: "Mount", device: "iPad", category: .music, title: "Concert", desc: "Listened to the orchestra")
        ]
        return raw.map { rawStamp in
            Stamp(from: rawStamp)
        }
    }
    
}
