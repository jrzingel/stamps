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
    case editLog(Log)
    case viewLog(Log)
    case history
    case mapSingleLog(Log)
}

// Add new view where you can select a category and see stats for it for all logs conforming to it

struct Sidebar: View {
    @ObservedObject var logManager = LogManager.shared
    @StateObject private var navigationStore = NavigationStore()
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack(path: $navigationStore.path) {
            List {
                Section {
                    NavigationLink(value: Destination.map) {
                        Label("Log map", systemImage: "map.fill")
                    }
                    
                    NavigationLink(value: Destination.history) {
                        Label("Log history", systemImage: "list.clipboard.fill")
                    }
                }
                    
                Section {
                    Button("Get last log", systemImage: "bolt.fill", action: { logManager.getLastLog(context: modelContext) })
                    
                    Button("Get last 100 logs", systemImage: "tray.and.arrow.down.fill", action: { logManager.getLastNLogs(context: modelContext, num: 100) })
                    
                } header: {
                    HStack {
                        Text("Endpoint API")
                        Spacer()
                        ProgressView()
                            .opacity(logManager.queryingApi ? 1 : 0)
                    }
                }
                
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Logs")
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .map:
                    MapView()
                case .editLog(let log):
                    EditLogView(log: log)
                case .viewLog(let log):
                    LogDetailView(log: log)
                case .history:
                    LogListView()
                case .mapSingleLog(let log):
                    SingleLogMapView(log: log)
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
