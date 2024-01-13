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
    @Query(sort: \Log.time, order: .reverse) var logs: [Log]
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var navigationStore: NavigationStore
    @State private var editMode: Bool = false
    
    var body: some View {
        List {
            ForEach(groupLogs(logs: logs)) { day in
                Section {
                    ForEach(day.logs) { log in
                        NavigationLink(value: self.editMode ? Destination.editLog(log) : Destination.viewLog(log)) {
                            LogRowView(log: log)
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
    
    /// Partition the logs by each day
    func groupLogs(logs: [Log]) -> [Day] {
        if logs.isEmpty {
            return [Day("no logs")]
        }
        var days = [Day]()
        
        var currentDay = Day(logs[0].time.date)     // Current day object
        
        for log in logs {
            if log.time.date != currentDay.day {
                // Save old day
                currentDay.reverseLogList()
                days.append(currentDay)
                // Create new day
                currentDay = Day(log.time.date)
            }
            currentDay.add(log)
        }
        if !currentDay.logs.isEmpty {
            currentDay.reverseLogList()
            days.append(currentDay)
        }
        print(days)
        return days
    }
    
    func addSamples() {
        let ls: [Log] = [
            Log(5625, 176.253, -37.526, "Te Puna", "iPhone", "COMMON", "sample log"),
            Log(5752, 176.253, -37.526, "Te Puna", "iPhone", "UNCOMMON", "dddd"),
            Log(5752, 176.253, -37.526, "Te Puna", "iPhone", "SLEEP", "dddd"),
            Log(44421, 176.253, -37.526, "Te Puke", "iPhone", "CODE", "morerrrr"),
            Log(44429, 176.253, -37.526, "Auckland", "iPhone", "UNI", "someothers")
            ]
        for l in ls {
            modelContext.insert(l)
        }
    }
    
    
    /// Delete some logs from the history if necessary
    func deleteLog(_ indexSet: IndexSet) {
        for index in indexSet {
            let log = logs[index]
            modelContext.delete(log)
        }
    }
    
    /// Create new log
    func addLog() {
        let log = Log()
        modelContext.insert(log)
        navigationStore.path = NavigationPath([Destination.history, Destination.editLog(log)])
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Log.self, configurations: config)
        
        return LogListView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
