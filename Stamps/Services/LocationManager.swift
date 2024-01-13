//
//  LocationManager.swift
//  Outline
//
//  Created by James Zingel on 16/12/23.
//

import MapKit
import CoreLocation

enum LocationError: Error {
    case reverseLookUpFailed(Error?)
}

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    public static var shared: LocationManager = LocationManager()
    private let manager = CLLocationManager()
    
    @Published var coords: CLLocationCoordinate2D?
    @Published var suburb: String?
    var lastLocation: CLLocation?
    
    // What to do after we have a new location and suburb
    var completion: (CLLocationCoordinate2D, String) -> Void = { _, __ in }
    
    internal override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.requestWhenInUseAuthorization()  // Ask permission
//        manager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map { location in
            self.lastLocation = location
            self.coords = location.coordinate
            print("New location: \(self.coords!)")
            
            // Look it up if not nil
            if let lastLocation {
                lookUpLocation(location: lastLocation) { result in
                    switch result {
                    case .success(let placemark):
                        if let country = placemark.isoCountryCode {
                            if let locality = placemark.locality {
                                if let suburb = placemark.subLocality {
                                    self.suburb = suburb + ", " + locality + " (" + country + ")"
                                } else {
                                    self.suburb = locality + " (" + country + ")"
                                }
                            } else {
                                self.suburb = country
                            }
                        } else if let locality = placemark.locality {
                            self.suburb = locality
                        } else {
                            Logger.location.error("Lookup suceeded but not with the fields we expected")
                        }
                    case .failure(let error):
                        Logger.location.error("Lookup error \(error)")
                    }
                    
                    self.completion(lastLocation.coordinate, self.suburb ?? "Unknown")
                    self.stop()
                }
            } else {
                Logger.location.error("Returned location but contains no location?")
            }
        }
    }
    
    // MARK: - CLLocationManager
    func refresh(completion: @escaping(CLLocationCoordinate2D, String) -> Void) {
        self.completion = completion
        Logger.location.info("Start updating location")
        manager.startUpdatingLocation()
    }
    
    func stop() {
        Logger.location.info("Stop updating location")
        manager.stopUpdatingLocation()
    }
    
    // MARK: - Proccess methods
    
    private func lookUpLocation(location: CLLocation, completion: @escaping(Result<CLPlacemark, Error>) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?[0] else { return completion(.failure(LocationError.reverseLookUpFailed(error))) }
            completion(.success(placemark))
        }
    }
}
