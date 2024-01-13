//
//  SingleLogMapView.swift
//  Outline
//
//  Created by James Zingel on 23/12/23.
//

import SwiftUI

// Only display the log shown.
// Use as a navigation link from viewing the log

struct SingleLogMapView: View {
    @ObservedObject var mapModel = MapModel.shared
    
    var log: Stamp
    
    var body: some View {
        ReducedMapView(content: .specificStamp(log))
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Menu("Map style", systemImage: "map.fill") {
                        Picker("Change maptype", selection: $mapModel.mapStyle) {
                            ForEach(Style.allCases) { style in
                                Text(style.rawValue.capitalized)
                            }
                        }
                    }
                }
            }
    }
}

#Preview {
    SingleLogMapView(log: SAMPLE_STAMPS[0])
}
