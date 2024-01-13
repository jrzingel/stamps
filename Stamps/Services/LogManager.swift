//
//  LogManager.swift
//  Outline
//
//  Created by James Zingel on 16/12/23.
//

import Foundation
import SwiftData

// Contains the current logs and requests more if necessary
// Consider this the bridge between SwiftData and the Endpoint API

final class LogManager: ObservableObject {
    public static var shared = LogManager()
    
    @Published var queryingApi = false
    
    internal init() { }
    
    // MARK: - GET
    
    /// Get more logs as specified from the API
    public func getLastLog(context: ModelContext) {
        queryingApi = true
        EndpointApi.getLastLog { result in
            switch result {
            case .failure(let error): Logger.api.error("Cannot get more logs: \(error)")
            case .success(let log):
                context.insert(log)
            }
            self.queryingApi = false
        }
    }
    
    /// Get the last n logs from the API
    public func getLastNLogs(context: ModelContext, num: Int) {
        queryingApi = true
        EndpointApi.getLastNLogs(num: num) { result in
            switch result {
            case .failure(let error): Logger.api.error("Cannot get last n=\(num) logs. \(error)")
            case .success(let logs):
                for log in logs {
                    context.insert(log)
                }
            }
            self.queryingApi = false
        }
        
    }
    
}
