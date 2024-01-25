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
            
            Image(systemName: stamp.isSynced ? "cloud.fill" : "cloud")
                .foregroundStyle(Color.accentColor)
            
            Spacer()
            Text(stamp.title)
            
        }
    }
}

#Preview {
    List {
        StampRowView(stamp: Stamp.samples[0])
        
        StampRowView(stamp: Stamp.samples[1])
    }
    .modelContainer(for: Stamp.self, inMemory: true)
}
