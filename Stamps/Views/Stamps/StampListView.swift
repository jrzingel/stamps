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

struct StampListView: View {
    @Query(sort: \Stamp.time, order: .reverse) var stamps: [Stamp]
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var navigationStore: NavigationStore
    @State private var editMode: Bool = false
    
    var body: some View {
        List {
            ForEach(groupStamps(stamps: stamps)) { day in
                Section {
                    ForEach(day.stamps) { log in
                        NavigationLink(value: self.editMode ? Destination.editStamp(log) : Destination.viewStamp(log)) {
                            StampRowView(stamp: log)
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
            
            Button("Sync", systemImage: "arrow.triangle.2.circlepath", action: {
                print("Sync with API")
            })
        }
    }
    
    /// Partition the stamps by each day
    func groupStamps(stamps: [Stamp]) -> [Day] {
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
        return days
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
        let stamp = Stamp()
        modelContext.insert(stamp)
        navigationStore.path = NavigationPath([Destination.history, Destination.editStamp(stamp)])
    }
}

#Preview {
    StampListView()
        .modelContainer(for: Stamp.self, inMemory: true)
}
