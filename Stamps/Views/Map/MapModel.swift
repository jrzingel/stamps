//
//  MapModel.swift
//  Outline
//
//  Created by James Zingel on 16/12/23.
//

import SwiftUI
import MapKit

enum Style: String, CaseIterable, Identifiable {
    case standard
    case satellite
    case hybrid
    
    var id: Self { self }
    
    var toMapStyle: MapStyle {
        switch self {
        case .standard: return .standard(emphasis: .automatic)
        case .satellite: return .imagery(elevation: .realistic)
        case .hybrid: return .hybrid
        }
    }
}


final class MapModel: ObservableObject {
    // Use the shared instance
    public static var shared: MapModel = MapModel()
    
    @Published var mapStyle: Style = .standard
    @Namespace var namespace
    
    internal init() {
        
    }
    
    
    
}
