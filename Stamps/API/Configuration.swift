//
//  Configuration.swift
//  Outline
//
//  Created by James on 9/12/23.
//

import Foundation
import Alamofire

struct AppSecrets: Decodable {
    private enum CodingKeys: String, CodingKey {
        case API_TOKEN
    }
    
    let API_TOKEN: String
}

public class Configuration: BaseBackendConfiguration {
    public let testing: Bool = true
    
    public var baseUrl: URLComponents {
        var components = URLComponents()
        components.scheme = "http"
        if testing {
            components.host = "thoughty2.local"
            components.port = 3000
        } else {
            components.host = "dev.zingel.nz"
        }
        return components
    }
    
    private func loadToken() -> String {
        // Force unwrapping everything as if this fails we want the app to crash...
        let url = Bundle.main.url(forResource: "AppSecrets", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let appSecrets = try! PropertyListDecoder().decode(AppSecrets.self, from: data)
        return appSecrets.API_TOKEN
    }
    
    public var authenticationHeaders: HTTPHeaders {
        var headers: HTTPHeaders = [: ]
        
        let token = loadToken()
        headers["Authorization"] = "Bearer \(token)"
        
        return headers
    }
}
