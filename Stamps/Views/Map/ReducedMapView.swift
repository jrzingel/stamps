//
//  ReducedMapView.swift
//  Outline
//
//  Created by James Zingel on 21/12/23.
//

import SwiftUI
import MapKit
import SwiftData

// Displays the actual map view. Controlled from `MapView` to receive the correct Logs to display

enum MapContent: Hashable {
    case lastLog
    case stampsAfter(Date)
    case specificLog(Stamp)
}

let DEFAULT_MAP_POSITION: MapCameraPosition = .userLocation(fallback: .region(MKCoordinateRegion(center: Coord.Tauranga.map, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))))

// TODO: Make the map dynamically zoom when changing

struct ReducedMapView: View {
    @ObservedObject var mapModel = MapModel.shared
    @State var position: MapCameraPosition = DEFAULT_MAP_POSITION
    @Query var stamps: [Stamp]
    // (sort: [SortDescriptor(\Log.time, order: .forward)])
    
    // Last log only
    init(content: MapContent) {
        // FIXME: Currently there appears to be a bug where we cannot test by enum condition. So we cannot search by Categories
        
        switch content {
        case .lastLog:
            Logger.general.info("MapView> Showing last log only")
            var descriptor = FetchDescriptor<Stamp>(sortBy: [SortDescriptor(\.time, order: .reverse)])
            descriptor.fetchLimit = 1
            _stamps = Query(descriptor)
            
        case .stampsAfter(let date):
            Logger.general.info("MapView> showing all stamps after \(date.date) \(date.time)")
            
            _stamps = Query(filter: #Predicate<Stamp> {
                $0.time > date
            })
            
        case .specificLog(let log):
            Logger.general.info("MapView> showing only the given log '\(log.log)'")
            let id = log.id
            _stamps = Query(filter: #Predicate<Stamp> {
                $0.id == id
            })
        }
    }
    
    var body: some View {
        let boundPosition = Binding<MapCameraPosition>(
            get: { updateCameraPosition(stamps) },  // FIXME: Currently this is called quite frequently... not the most optimal
            set: { self.position = $0}
        )
        
        return Map(position: boundPosition, interactionModes: [.pan, .rotate, .zoom]) {
            
            ForEach(stamps) { log in
                Marker(log.log, coordinate: log.coord.map)
            }
            
            UserAnnotation()
        }
        .mapControls {
            MapCompass()
            MapUserLocationButton()
            MapScaleView()
        }
        .mapStyle(mapModel.mapStyle.toMapStyle)
    }
    
    // MARK: - Methods
    
    /// Update the camera position to contain all the stamps present
    func updateCameraPosition(_ stamps: [Stamp]) -> MapCameraPosition {
        // Coordinate math...
        Logger.general.info("MapView> Recalculating initial map coordinate region")
        if stamps.isEmpty {
            return DEFAULT_MAP_POSITION
        }
        var minLat = stamps[0].coord.latitude
        var maxLat = stamps[0].coord.latitude
        var minLon = stamps[0].coord.longitude
        var maxLon = stamps[0].coord.longitude
        for log in stamps {
            if log.coord.latitude > maxLat { maxLat = log.coord.latitude }
            if log.coord.latitude < minLat { minLat = log.coord.latitude }
            if log.coord.longitude > maxLon { maxLon = log.coord.longitude }
            if log.coord.longitude < minLon { minLon = log.coord.longitude }
        }
        let center = CLLocationCoordinate2D(latitude: (minLat+maxLat)/2, longitude: (minLon+maxLon)/2)
        let zoomOutScale = 1.2  // How far to scale out from the edges
        let latDelta = max((maxLat-minLat) * zoomOutScale, 0.01)
        let lonDelta = max((maxLon-minLon) * zoomOutScale, 0.01)
        return .region(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)))
    }
}

#Preview {
    ReducedMapView(content: .lastLog)
}
