//
//  DeviceManager.swift
//  Outline
//
//  Created by James Zingel on 20/12/23.
//

import SwiftUI

// What device are we currently using?

enum Devices: CustomStringConvertible {
    case iPhone
    case mac
    case watch
    case iPad
    
    var description: String {
        // To match the current device description
        switch self {
        case .iPhone: return "iPhone"
        case .mac: return "Mac"
        case .watch: return "Apple Watch"
        case .iPad: return "iPad"
        }
    }
    
    static var this: Self {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad: return .iPad
        case .mac: return .mac
        case .phone: return .iPhone
        default: return .iPhone
        }
    }
}
