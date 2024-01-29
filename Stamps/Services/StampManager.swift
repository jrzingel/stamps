//
//  LogManager.swift
//  Outline
//
//  Created by James Zingel on 16/12/23.
//

import Foundation
import SwiftData

// Contains the current stamps and requests more if necessary
// Consider this the bridge between SwiftData and the Endpoint API

final class StampManager: ObservableObject {
    public static var shared = StampManager()
    
    @Published var queryingApi = false
    
    internal init() { }
    
    // MARK: - GET
    

    
}
