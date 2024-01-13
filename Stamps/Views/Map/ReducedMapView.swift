//
//  ReducedMapView.swift
//  Outline
//
//  Created by James Zingel on 21/12/23.
//

import SwiftUI
import MapKit
import SwiftData

// Displays the actual map view. Controlled from `MapView` to receive the correct stamps to display

enum MapContent: Hashable {
    case lastStamp
    case stampsAfter(Date)
    case specificStamp(Stamp)
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
        case .lastStamp:
            Logger.general.info("MapView> Showing last log only")
            var descriptor = FetchDescriptor<Stamp>(sortBy: [SortDescriptor(\.time, order: .reverse)])
            descriptor.fetchLimit = 1
            _stamps = Query(descriptor)
            
        case .stampsAfter(let date):
            Logger.general.info("MapView> showing all stamps after \(date.date) \(date.time)")
            
            _stamps = Query(filter: #Predicate<Stamp> {
                $0.time > date
            })
            
        case .specificStamp(let stamp):
            Logger.general.info("MapView> showing only the given stamp'\(stamp.title)'")
            let id = stamp.id
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
            
            // FIXME: Update the method used in earthquake demo app
            ForEach(stamps) { stamp in
                Marker(stamp.title, coordinate: stamp.coords[0].map)
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
        var minLat = stamps[0].coords[0].latitude
        var maxLat = stamps[0].coords[0].latitude
        var minLon = stamps[0].coords[0].longitude
        var maxLon = stamps[0].coords[0].longitude
        for log in stamps {
            if log.coords[0].latitude > maxLat { maxLat = log.coords[0].latitude }
            if log.coords[0].latitude < minLat { minLat = log.coords[0].latitude }
            if log.coords[0].longitude > maxLon { maxLon = log.coords[0].longitude }
            if log.coords[0].longitude < minLon { minLon = log.coords[0].longitude }
        }
        let center = CLLocationCoordinate2D(latitude: (minLat+maxLat)/2, longitude: (minLon+maxLon)/2)
        let zoomOutScale = 1.2  // How far to scale out from the edges
        let latDelta = max((maxLat-minLat) * zoomOutScale, 0.01)
        let lonDelta = max((maxLon-minLon) * zoomOutScale, 0.01)
        return .region(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)))
    }
}

#Preview {
    ReducedMapView(content: .lastStamp)
}
