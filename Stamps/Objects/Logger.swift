//
//  Logger.swift
//  Outline
//
//  Created by James Zingel on 30/11/23.
//

import Foundation
import os

/// Global App loggers
public enum Logger {
    /// Logger for any other messages
    public static let general = os.Logger(subsystem: Bundle.main.bundleIdentifier!, category: "general")
    public static let api = os.Logger(subsystem: Bundle.main.bundleIdentifier!, category: "api")
    public static let location = os.Logger(subsystem: Bundle.main.bundleIdentifier!, category: "location")
}
