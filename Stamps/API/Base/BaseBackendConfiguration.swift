//
//  BaseBackendConfiguration.swift
//  Stamps
//
//  Created by James on 29/01/24.
//

import Foundation
import Alamofire

public protocol BaseBackendConfiguration {
    var baseUrl: URLComponents { get }
    var authenticationHeaders: HTTPHeaders { get }
}


extension BaseBackendConfiguration {
    public static var userAgent: String {
        if let info = Bundle.main.infoDictionary {
            let executable: Any = info[kCFBundleExecutableKey as String] ?? "Unknown"
            let version = info["CFBundleShortVersionString"] ?? "Unknown"
            #if os(iOS)
            let deviceModel = UIDevice.current.model
            let osVersion = UIDevice.current.systemVersion
            return "\(executable)/\(version) (iOS \(osVersion) \(deviceModel))"
            #else
            let deviceModel = ProcessInfo.processInfo.hostName
            let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
            return "\(executable)/\(version) (macOS \(osVersion) \(deviceModel))"
            #endif
        }
        return "Unknown"
    }
    
    var defaultHeaders: HTTPHeaders {
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        let userAgent: String = Self.userAgent
        
        return [
            "Accept-Encoding": acceptEncoding,
            "User-Agent": userAgent,
        ]
    }
}
