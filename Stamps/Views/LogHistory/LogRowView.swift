//
//  LogRowView.swift
//  Outline
//
//  Created by James Zingel on 14/12/23.
//

import SwiftUI
import SwiftData

struct LogRowView: View {
    var log: Stamp
    
    var body: some View {
        HStack {
            Image(systemName: log.icon)
                .foregroundStyle(log.color)
            
            Text("\(log.time.time)")
            
            
            Spacer()
            Text(log.log)
            
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Stamp.self, configurations: config)
        
        return List {
            LogRowView(log: SAMPLE_STAMPS[0])
            
            LogRowView(log: SAMPLE_STAMPS[1])
        }
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
    
}
