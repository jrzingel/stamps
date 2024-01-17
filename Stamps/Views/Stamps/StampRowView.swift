//
//  LogRowView.swift
//  Outline
//
//  Created by James Zingel on 14/12/23.
//

import SwiftUI
import SwiftData

struct StampRowView: View {
    var stamp: Stamp
    
    var body: some View {
        HStack {
            Image(systemName: stamp.icon)
                .foregroundStyle(stamp.color)
            
            Text("\(stamp.time.time)")
            
            
            Spacer()
            Text(stamp.title)
            
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Stamp.self, configurations: config)
        
        return List {
            StampRowView(stamp: SAMPLE_STAMPS[0])
            
            StampRowView(stamp: SAMPLE_STAMPS[1])
        }
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
    
}
