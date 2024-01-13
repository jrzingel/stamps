//
//  NewLogView.swift
//  Outline
//
//  Created by James Zingel on 17/12/23.
//

import SwiftUI
import SwiftData

// Create a new log based on the current category
// Allow a selection of the desired options
// Different categories should offer different defaults!

struct EditLogView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @State var locationUpdating = false
    
    @Bindable var log: Log
    
    // TEMP variables
    @State private var isSpecial: Bool = false
    
    
    var body: some View {
        Form {
            DatePicker("Time", selection: $log.time)
            
            Toggle(isOn: $isSpecial) {
                Text("Special log")
            }
            
            Picker("Category", selection: $log.category)  {
                ForEach(Category.allCases) { category in
                    HStack {
                        Text(category.description)
                        Spacer()
                        Image(systemName: category.icon)
                    }
                }
            }
            
            // Custom information to enter
            switch log.category.selection {
            case .any:
                Section {
                    TextField("Enter new log", text: $log.log)
                } header: { Text("Create new log")}
                
                // TODO: Add query here to suggest similar logs entered in the past
                
            case .restricted(let options):
                Section {
                    ForEach(options, id: \.self) { option in
                        SelectionCell(log: option, selectedLog: $log.log)
                    }
                } header: { Text("Select new log")}
                
            case .singleton(let value):
                Section {
                    SelectionCell(log: value, selectedLog: $log.log)
                } header: { Text("Log") }
                
            case .invalid:
                Section {
                    Text("The current log type is legacy only and cannot be updated. Please use another log type instead.")
                }
            }
            
            // Base information that cannot change
            Section {
                Label(log.coord.description, systemImage: "mappin.and.ellipse")
                
                Label(log.suburb, systemImage: "house.fill")
                
                Button {
                    updateLocation()
                } label: {
                    HStack {
                        Text("Set as Current Location")
                        
                        Spacer()
                        
                        ProgressView()
                            .opacity(locationUpdating ? 1 : 0)
                    }
                }
                
                
            } header: {
                Text("Location")
            }
            
            Section {
                Label(log.device, systemImage: "pc")
                
                Label(log.category.description, systemImage: "shippingbox.fill")
            } header: {
                Text("Non-Configurable")
            }
        }
        .onAppear {
            if log.coord.isZero {
                updateLocation()
            }
        }
        
    }
    
    func updateLocation() {
        self.locationUpdating = true
        Logger.location.info("Updating log info")
        locationManager.refresh { coord, suburb in
            log.coord = coord.toCoord()
            log.suburb = suburb
            self.locationUpdating = false
        }
    }
}

struct SelectionCell: View {
    let log: String
    @Binding var selectedLog: String
    
    var body: some View {
        HStack {
            Text(log)
            Spacer()
            if log == selectedLog {
                Image(systemName: "checkmark")
            }
        }
        .contentShape(Rectangle())
        //.background(Color.red)
        .onTapGesture {
            self.selectedLog = self.log
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .foregroundStyle(selectedLog == log ? Color.white : Color.black)
        .background(selectedLog == log ? Color.accentColor : nil)
        .cornerRadius(6)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Log.self, configurations: config)
        
        let example = Log(5625, 176.253, -37.526, "Te Puna", "iPhone", "COMMON", "sample log")
        return EditLogView(log: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Log.self, configurations: config)
        
        let example = Log(5625, 176.253, -37.526, "Te Puna", "iPhone", "CODE", "sample log")
        return EditLogView(log: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

//#Preview {
//    NewLogView(category: .code)
//}
