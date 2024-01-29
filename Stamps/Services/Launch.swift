//
//  Launch.swift
//  Stamps
//
//  Created by James on 29/01/24.
//

import Foundation

/// Setup to run on app launch
func launch() {
    // Install the networking plugin
    
    BaseCommand.plugins = [NetworkLoggerPlugin()]
}
