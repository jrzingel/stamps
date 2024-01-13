//
//  MapView.swift
//  Outline
//
//  Created by James Zingel on 14/12/23.
//

import SwiftUI
import MapKit
import SwiftData


// Presents a map containing the log

// Presets for `MapContent`
enum MapContentPresets: Hashable, CaseIterable, Identifiable, CustomStringConvertible {
    case lastLog
    case lastWeek
    case lastMonth
    
    var id: Self { self }
    
    var toMapContent: MapContent {
        switch self {
        case .lastLog: return .lastLog
        case .lastWeek: return .stampsAfter(Date().aWeekAgo)
        case .lastMonth: return .stampsAfter(Date().aMonthAgo)
        }
    }
    
    var description: String {
        switch self {
        case .lastLog: return "Last log"
        case .lastWeek: return "Last week"
        case .lastMonth: return "Last month"
        }
    }
}

struct MapView: View {
    @ObservedObject var mapModel = MapModel.shared
    @State var mapContent: MapContentPresets = .lastLog
    
    // Display the given log if given. Otherwise default to last log
    
    var body: some View {
        //Map(position: .constant(.region(region)))
        ReducedMapView(content: mapContent.toMapContent)
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Menu("Map style", systemImage: "map.fill") {
                        Picker("Change maptype", selection: $mapModel.mapStyle) {
                            ForEach(Style.allCases) { style in
                                Text(style.rawValue.capitalized)
                            }
                        }
                    }
                    
                    Menu("Displayed stamps", systemImage: "calendar") {
                        Picker("Content", selection: $mapContent) {
                            ForEach(MapContentPresets.allCases) { preset in
                                Text(preset.description)
                                    .tag(preset)
                            }
                        }
                        .pickerStyle(.inline)
                    }
                }
            }
    }
}

#Preview {
    MapView()
}
