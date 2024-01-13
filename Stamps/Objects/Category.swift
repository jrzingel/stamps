//
//  Category.swift
//  Outline
//
//  Created by James Zingel on 14/12/23.
//

import SwiftUI

// All the different log types... Gotta catch em all
// Note that as `Type` is reserved in swift these are known as "categories" on iOS

enum Category: CustomStringConvertible, CaseIterable, Codable, Identifiable {
    
    case generic
    case common
    case uncommon
    case code
    case uni
    case sleep
    case travel
    case tech
    case future  // Legacy type used when the timestamp was not current
    case work
    case resolution
    case music
    case activity
    
    case unknown    // Only use if type conversion fails
    
    // MARK: - Generated methods
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .generic: return "Generic"
        case .common: return "Common"
        case .uncommon: return "Uncommon"
        case .code: return "Code"
        case .uni: return "University"
        case .sleep: return "Sleep"
        case .travel: return "Travel"
        case .tech: return "Technology"
        case .future: return "Future (deprecated)"
        case .work: return "Work"
        case .resolution: return "Resolution"
        case .music: return "Music"
        case .activity: return "Activity"
            
        case .unknown: return "Unknown"
        }
    }
    
    // Consistent color for each category
    var color: Color {
        switch self {
        case .generic: return .indigo
        case .common: return .green
        case .uncommon: return .green
        case .code: return .orange
        case .uni: return .blue
        case .sleep: return .orange
        case .travel: return .purple
        case .tech: return .red
        case .future: return .gray
        case .work: return .blue
        case .resolution: return .green
        case .music: return .orange
        case .activity: return .purple
            
        case .unknown: return .gray
        }
    }
    
    // System Icon to represent the category
    var icon: String {
        switch self {
        case .generic: return "bookmark.fill"
        case .common: return "binoculars.fill"
        case .uncommon: return "puzzlepiece.fill"
        case .code: return "externaldrive.connected.to.line.below.fill"
        case .uni: return "books.vertical.fill"
        case .sleep: return "bed.double.fill"
        case .travel: return "airplane.departure"
        case .tech: return "gamecontroller.fill"
        case .future: return "arrow.2.squarepath"
        case .work: return "hammer.fill"
        case .resolution: return "fireworks"
        case .music: return "music.quarternote.3"
        case .activity: return "bicycle"
            
        case .unknown: return "questionmark.app.dashed"
        }
    }
    
    // Use instead of `CaseIterable` to remove "unknown" option.
    static var allCases: [Category] {
        return [.generic, .common, .uncommon, .code, .uni, .sleep, .travel, .tech, .work, .resolution, .music, .activity]
    }
    
    // TODO: Allow optional varients that can dynamically change. (Eg uni class -> class/study etc)
    // TODO: Add varient that skips customization (Eg sleep mode)
    // What should the new log screen present?
    enum Selection {
        case any                        // Anything is valid
        case restricted([String])       // Only set options are valid
        case singleton(String)          // One one option is valid (effectively ignored)
        case invalid                    // New stamps should not conform to this type of category
    }
    
    // the associated selection if applicable. These are not enforced on old stamps but new stamps must conform to them
    // NOTE: Each categories options must be distinct! (Otherwise the app will crash later)
    var selection: Selection {
        switch self {
        case .generic: return .any
        case .common: return .restricted(["Walk", "Dishes", "Cook", "Rise", "Breakfast", "Lunch", "Dinner"])
        case .uncommon: return .restricted(["supermaket", "haircut", "washing", "church", "friends", "family", "talk", "tidy", "facetime"])
        case .code: return .any
        case .uni: return .any
        case .sleep: return .singleton("begin sleep mode")
        case .travel: return .any   // TODO: Create 'from' and 'to' methods
        case .tech: return .any     // TODO: Create youtube selection with custom options of others
        case .work: return .singleton("safesurfer")
        case .resolution: return .restricted(["Read novel", "Write something", "Kaggle", "Sit and wait"])
        case .music: return .restricted(["Piano", "Trombone", "Guitar", "Listen"])
        case .activity: return .restricted(["Toastmasters", "Run", "Bike for commute", "Bike", "Fly Drone", "Commute", "Swim", "geocaching"])
            
        case .future: return .invalid
        case .unknown: return .invalid
        }
    }
}

extension String {
    func toCategory() -> Category {
        switch self {
        case "": return .generic
        case "COMMON": return .common
        case "UNCOMMON": return .uncommon
        case "CODE": return .code
        case "UNI": return .uni
        case "SLEEP": return .sleep
        case "TRAVEL": return .travel
        case "TECH": return .tech
        case "WORK": return .work
        case "RESOLUTION": return .resolution
        case "MUSIC": return .music
        case "ACTIVITY": return .activity
        case "FUTURE": return .future
        default: return .unknown
        }
    }
}
