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
    
    /// Get more stamps as specified from the API
    public func getLastStamp(context: ModelContext) {
        queryingApi = true
        EndpointApi.getLastLog { result in
            switch result {
            case .failure(let error): Logger.api.error("Cannot get more stamps: \(error)")
            case .success(let log):
                context.insert(log)
            }
            self.queryingApi = false
        }
    }
    
    /// Get the last n stamps from the API
    public func getLastNStamps(context: ModelContext, num: Int) {
        queryingApi = true
        EndpointApi.getLastNLogs(num: num) { result in
            switch result {
            case .failure(let error): Logger.api.error("Cannot get last n=\(num) stamps. \(error)")
            case .success(let stamps):
                for log in stamps {
                    context.insert(log)
                }
            }
            self.queryingApi = false
        }
        
    }
    
}
