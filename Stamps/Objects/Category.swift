//
//  Category.swift
//  Outline
//
//  Created by James Zingel on 14/12/23.
//

import SwiftUI

// FIXME: Update from log category to stamp categories. Eg walk, explore, hangout, etc

/// The different types a stamp can be
enum Category: CustomStringConvertible, CaseIterable, Codable, Identifiable {
    
    case none
    
    case code
    case travel
    case resolution
    case music
    case activity
    
    // MARK: - Generated methods
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .none: return "none"
            
        case .code: return "Code"
        case .travel: return "Travel"
        case .resolution: return "Resolution"
        case .music: return "Music"
        case .activity: return "Activity"
        }
    }
    
    // Consistent color for each category
    var color: Color {
        switch self {
        case .none: return .gray
            
        case .code: return .orange
        case .travel: return .purple
        case .resolution: return .green
        case .music: return .orange
        case .activity: return .purple
        }
    }
    
    // System Icon to represent the category
    var icon: String {
        switch self {
        case .none: return "questionmark.app.dashed"
            
        case .code: return "externaldrive.connected.to.line.below.fill"
        case .travel: return "airplane.departure"
        case .resolution: return "fireworks"
        case .music: return "music.quarternote.3"
        case .activity: return "bicycle"
        }
    }
}

extension String {
    func toCategory() -> Category {
        switch self {
        case "CODE": return .code
        case "TRAVEL": return .travel
        case "RESOLUTION": return .resolution
        case "MUSIC": return .music
        case "ACTIVITY": return .activity
        default: return .none
        }
    }
}
