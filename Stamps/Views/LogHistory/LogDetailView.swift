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

struct LogDetailView: View {
    @ObservedObject var mapModel = MapModel.shared
    var log: Stamp
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                HStack(alignment: .center){
                    Spacer()
                    
                    Text(log.log)
                        .font(.title)
                    
                    Image(systemName: log.icon)
                        .font(.title)
                        .foregroundStyle(log.color)
                }
                .padding()
                
                Text(log.time.time)
                
                
                List {
                    Group {
                        Section {
                            Label(log.suburb, systemImage: "house.fill")
                            
                            Label(log.device, systemImage: "pc")
                            
                            Label(log.category.description, systemImage: "shippingbox.fill")
                        }
                        
                        Section {
                            NavigationLink(value: Destination.mapSingleLog(log)) {
                                Label("See in map", systemImage: "map.fill")
                            }
                        }
                    }
                    .listRowBackground(Color(UIColor.quaternarySystemFill))
                }
                .frame(width: geometry.size.width, height: 300, alignment: .center)
                .scrollContentBackground(.hidden)
                
                ZStack {
                    Rectangle()
                        .frame(height: 5)
                    
                    HStack {
                        Circle()
                        Spacer()
                        Circle()
                    }
                    .frame(height: 10)
                    .padding()
                }
                .foregroundStyle(.blue)
                
//                MapView()  FIXME: Convert to navigation link
//                    .frame(minHeight: 300)
                
                Spacer()
            }
            //            .scrollIndicators(.visible)
        }
//        .ignoresSafeArea(.container, edges: [.top])
        .onAppear {
            print("Move camera to log: \(log.log)")
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Stamp.self, configurations: config)
        
        return LogDetailView(log: SAMPLE_STAMPS[0])
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
