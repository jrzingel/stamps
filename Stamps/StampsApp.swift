//
//  StampsApp.swift
//  Stamps
//
//  Created by James Zingel on 7/01/24.
//

import SwiftUI
import SwiftData

@main
struct StampsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Stamp.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Sidebar()
        }
        .modelContainer(sharedModelContainer)
    }
}
