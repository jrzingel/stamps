//
//  LogView.swift
//  Outline
//
//  Created by James on 10/12/23.
//

import SwiftUI
import SwiftData

// TODO: Add some information like how far away the log was and how long ago it occured
// Perhaps also some information about the number of stamps that occured like this?

struct StampDetailView: View {
    @ObservedObject var mapModel = MapModel.shared
    var stamp: Stamp
    
    var body: some View {
        List {
            HStack(alignment: .center){
                Spacer()
                
                Text(stamp.title)
                    .font(.title)
                
                Image(systemName: stamp.icon)
                    .font(.title)
                    .foregroundStyle(stamp.color)
            }
            .padding()
            
            Text(stamp.time.time)
            
            Section {
                Text(stamp.desc)
            } header: { Text("Description") }
            
            
            Section {
                Label(stamp.suburb, systemImage: "house.fill")
                
                Label(stamp.device, systemImage: "pc")
                
                Label(stamp.category.description, systemImage: "shippingbox.fill")
            } header: { Text("Configuration")}
            
            Section {
                NavigationLink(value: Destination.mapSingleLog(stamp)) {
                    Label("See in map", systemImage: "map.fill")
                }
            }
            
            Section {
                Button {
                    UIApplication.shared.open(URL(string:"photos-redirect://")!)
                } label: {
                    Text("Open photos")
                }
            }
            
            .toolbar {
                NavigationLink(value: Destination.editStamp(stamp)) {
                    Text("Edit")
                    //                    Label("Edit", systemImage: "")
                }
            }
        }
        .navigationTitle("Stamp")
        .onAppear {
            print("Revision \(revision(stamp: stamp.raw))")
        }
    }
}

#Preview {
    StampDetailView(stamp: Stamp.samples[0])
        .modelContainer(for: Stamp.self, inMemory: true)
}
