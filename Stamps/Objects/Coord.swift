//
//  Coord.swift
//  Outline
//
//  Created by James Zingel on 18/12/23.
//

import Foundation
import MapKit


struct Coord: Codable, CustomStringConvertible {
    var longitude: Double
    var latitude: Double
    
    var map: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var description: String {
        // Print the coords in a DMS format like "37 32.323 S, 176 32.323 E"
        let lon = longitude.toDMS()
        let lat = latitude.toDMS()
        return String(format: "%d° %d'%d\" %@ %d° %d'%d\" %@",
                      abs(lat.degrees), lat.minutes, lat.seconds, lat.degrees >= 0 ? "N" : "S",
                      abs(lon.degrees), lon.minutes, lon.seconds, lon.degrees >= 0 ? "E" : "W")
    }
    
    var isZero: Bool {
        return longitude.isZero && latitude.isZero
    }
    
    // MARK: - Initilisers
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init(longitude: String, latitude: String) {
        self.longitude = Double(longitude) ?? 0.0
        self.latitude = Double(latitude) ?? 0.0
    }
    
    // Grab current location
    init() {
        self.longitude = 0.0
        self.latitude = 0.0
    }
    
    // MARK: - Useful locations
    static var Tauranga: Self {
        return Coord(longitude: 176.168203, latitude: -37.679284)
    }
}


extension Double {
    func toDMS() -> (degrees: Int, minutes: Int, seconds: Int) {
        var seconds = Int(self * 3600)
        let degrees = seconds / 3600
        seconds = abs(seconds % 3600)
        return (degrees, seconds / 60, seconds % 60)
    }
}

extension CLLocationCoordinate2D {
    func toCoord() -> Coord {
        return Coord(longitude: self.longitude, latitude: self.latitude)
    }
}
