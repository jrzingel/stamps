//
//  PrettyIcon.swift
//  demoing
//
//  Created by James Zingel on 20/11/23.
//

// Pretty icon builder
// Replicates the icons found in Settings.app

import SwiftUI

struct PrettyIcon: View {
    var icon: String
    var backgroundColor: Color
    var iconColor: Color = .white
    var size: CGFloat  // Scale the entire icon
    var iconScale: CGFloat = 1  // Scale the icon larger (box the same size)
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 9 * size)
                .foregroundStyle(backgroundColor)
                .frame(width: 35 * size, height: 35 * size)
            
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
//                .symbolRenderingMode(.palette)
//                .symbolVariant(.none)
                .foregroundStyle(iconColor)
                .frame(width: 27 * size * iconScale, height: 27 * size * iconScale)
        }
    }
}

#Preview {
    VStack {
        PrettyIcon(icon: "network", backgroundColor: Color.purple, size: 1)
        PrettyIcon(icon: "eye.trianglebadge.exclamationmark.fill", backgroundColor: Color.green, size: 1, iconScale: 1.2)
        PrettyIcon(icon: "wifi", backgroundColor: Color.blue, size: 1)
    }
}
