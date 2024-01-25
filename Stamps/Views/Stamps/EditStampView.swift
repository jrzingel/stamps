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

struct EditStampView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @State var locationUpdating = false
    
    @Bindable var stamp: Stamp
    
    
    var body: some View {
        Form {
            Section {
                DatePicker("Time", selection: $stamp.time)
                
                Picker("Category", selection: $stamp.category)  {
                    ForEach(Category.allCases) { category in
                        HStack {
                            Text(category.description)
                            Spacer()
                            Image(systemName: category.icon)
                        }
                    }
                }
                
                Label(stamp.device, systemImage: "pc")
            } header: { Text("Base configuration")}
            
            // MARK: Stamp info
            
            Section {
                TextField("Enter new log", text: $stamp.title)
            } header: { Text("Title") }
            
            Section {
                TextField("Description", text: $stamp.desc, axis: .vertical)
                    .lineLimit(5...10)
            } header: { Text("Description")}
            
            // TODO: Add query here to suggest similar stamps entered in the past
            
            
            // MARK: Locations
            
            // TODO: Add indicator of how far away these logs are
            Section {
                ForEach(stamp.coords.indices, id: \.self) { index in
                    Label(title: {
                        HStack {
                            Text(stamp.coords[index].description)
                            Spacer()
                            Button {
                                updateLocation(index: index)
                            } label: {
                                Image(systemName: "location.circle.fill")
                            }
                        }
                    }, icon: { Image(systemName: index.toLetter() + ".square")})
                }
 
            } header: {
                HStack {
                    Text("Locations")
                    Spacer()
                    Button {
                        stamp.coords.append(Coord())
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            

        }
        .onAppear {
            if stamp.coords[0].isZero {
                updateLocation(index: 0)
            }
        }
        .navigationTitle("Edit Stamp")
        
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
        return EditStampView(stamp: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

