//
//  LogListView.swift
//  Outline
//
//  Created by James Zingel on 18/12/23.
//

import SwiftUI
import SwiftData

// TODO: Group by date
// Have each day as a different section with
// TODO: Show upload button

struct LogListView: View {
    @Query(sort: \Stamp.time, order: .reverse) var stamps: [Stamp]
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var navigationStore: NavigationStore
    @State private var editMode: Bool = false
    
    var body: some View {
        List {
            ForEach(groupLogs(stamps: stamps)) { day in
                Section {
                    ForEach(day.stamps) { log in
                        NavigationLink(value: self.editMode ? Destination.editLog(log) : Destination.viewLog(log)) {
                            LogRowView(stamp: log)
                        }
                    }
                    .onDelete(perform: deleteLog)
                } header: { Text(day.day) }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Log History")
        .toolbar {
            Button("Add log", systemImage: "plus", action: addLog)
            
            Button(self.editMode ? "Done" : "Edit", action: { self.editMode.toggle() })
        }
        .onAppear {
            #if targetEnvironment(simulator)
            addSamples()
            #endif
        }
    }
    
    /// Partition the stamps by each day
    func groupLogs(stamps: [Stamp]) -> [Day] {
        if stamps.isEmpty {
            return [Day("no stamps")]
        }
        var days = [Day]()
        
        var currentDay = Day(stamps[0].time.date)     // Current day object
        
        for log in stamps {
            if log.time.date != currentDay.day {
                // Save old day
                currentDay.reverseLogList()
                days.append(currentDay)
                // Create new day
                currentDay = Day(log.time.date)
            }
            currentDay.add(log)
        }
        if !currentDay.stamps.isEmpty {
            currentDay.reverseLogList()
            days.append(currentDay)
        }
        print(days)
        return days
    }
    
    func addSamples() {
        let ls: [Stamp] = [
            Stamp(5625, 176.253, -37.526, "Te Puna", "iPhone", "COMMON", "sample log"),
            Stamp(5752, 176.253, -37.526, "Te Puna", "iPhone", "UNCOMMON", "dddd"),
            Stamp(5752, 176.253, -37.526, "Te Puna", "iPhone", "SLEEP", "dddd"),
            Stamp(44421, 176.253, -37.526, "Te Puke", "iPhone", "CODE", "morerrrr"),
            Stamp(44429, 176.253, -37.526, "Auckland", "iPhone", "UNI", "someothers")
            ]
        for l in ls {
            modelContext.insert(l)
        }
    }
    
    
    /// Delete some stamps from the history if necessary
    func deleteLog(_ indexSet: IndexSet) {
        for index in indexSet {
            let log = stamps[index]
            modelContext.delete(log)
        }
    }
    
    /// Create new log
    func addLog() {
        let log = Stamp()
        modelContext.insert(log)
        navigationStore.path = NavigationPath([Destination.history, Destination.editLog(log)])
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Stamp.self, configurations: config)
        
        return LogListView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
