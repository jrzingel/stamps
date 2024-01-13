//
//

import Foundation
import Alamofire

public protocol BaseConfiguration {
    var baseUrl: URLComponents { get }
    var authenticationHeaders: HTTPHeaders { get }
}

extension BaseConfiguration {
    public static var userAgent: String {
        if let info = Bundle.main.infoDictionary {
            let executable: Any = info[kCFBundleExecutableKey as String] ?? "Unknown"
            let version = info["CFBundleShortVersionString"] ?? "Unknown"
            let deviceModel = UIDevice.current.localizedModel
            let osVersion = UIDevice.current.systemVersion
            return "\(executable)/\(version) (iOS \(osVersion) \(deviceModel))"
        }
        return "Unknown user agent"
    }
    
    var defaultHeaders: [String: String] {
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        let userAgent: String = Self.userAgent
        
        return [
            "Accept-Encoding": acceptEncoding,
            "User-Agent": userAgent,
        ]
    }
}
