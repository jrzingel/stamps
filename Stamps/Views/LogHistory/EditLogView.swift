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
    
    @Bindable var stamp: Stamp
    
    // TEMP variables
    @State private var isSpecial: Bool = false
    
    
    var body: some View {
        Form {
            Section {
                DatePicker("Time", selection: $stamp.time)
                
                Toggle(isOn: $isSpecial) {
                    Text("Special log")
                }
                
                Picker("Category", selection: $stamp.category)  {
                    ForEach(Category.allCases) { category in
                        HStack {
                            Text(category.description)
                            Spacer()
                            Image(systemName: category.icon)
                        }
                    }
                }
            } header: { Text("Base configuration")}
            
            // Custom information to enter
            Section {
                TextField("Enter new log", text: $stamp.title)
            } header: { Text("Title") }
            
            // TODO: Add query here to suggest similar stamps entered in the past
            
            
            // Base information that cannot change
            Section {
                Label(stamp.coords[0].description, systemImage: "mappin.and.ellipse")
                
                Button {
                    updateLocation(index: 0)
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
                Label(stamp.device, systemImage: "pc")
                
                Label(stamp.category.description, systemImage: "shippingbox.fill")
            } header: {
                Text("Non-Configurable")
            }
        }
        .onAppear {
            if stamp.coords[0].isZero {
                updateLocation(index: 0)
            }
        }
        
    }
    
    func updateLocation(index: Int) {
        self.locationUpdating = true
        Logger.location.info("Updating log info")
        locationManager.refresh { coord, suburb in
            stamp.coords[index] = coord.toCoord()
            //            stamp.suburb = suburb
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
        let container = try ModelContainer(for: Stamp.self, configurations: config)
        
        let example = Stamp()
        return EditLogView(stamp: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

