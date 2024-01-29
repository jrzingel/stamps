//
//  Sidebar.swift
//  Stamps
//
//  Created by James on 10/12/23.
//

import SwiftUI
import MapKit


/// Where the navigation stack can take us
enum Destination: Hashable {
    case map
    case editStamp(Stamp)
    case viewStamp(Stamp)
    case history
    case mapSingleLog(Stamp)
    case settings
}

// Add new view where you can select a category and see stats for it for all stamps conforming to it

struct Sidebar: View {
    @ObservedObject var logManager = StampManager.shared
    @StateObject private var navigationStore = NavigationStore()
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack(path: $navigationStore.path) {
            List {
                Section {
//                    NavigationLink(value: Destination.map) {
//                        Label("Log map", systemImage: "map.fill")
//                    }
                    
                    NavigationLink(value: Destination.history) {
                        Label("Log history", systemImage: "list.clipboard.fill")
                    }
                }
                
                Section {
                    NavigationLink(value: Destination.settings) {
                        Label("Settings", systemImage: "gear")
                    }
                }
                
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Logs")
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .map:
                    MapView()
                case .editStamp(let log):
                    EditStampView(stamp: log)
                case .viewStamp(let log):
                    StampDetailView(stamp: log)
                case .history:
                    StampListView()
                case .mapSingleLog(let log):
                    SingleLogMapView(log: log)
                case .settings:
                    SettingsView()
                }
            }
        }
        .environmentObject(navigationStore)
    }
}

struct LogHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
