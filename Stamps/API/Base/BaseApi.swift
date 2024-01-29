//
//  BaseApi.swift
//  Stamps
//
//  Created by James on 29/01/24.
//

import Foundation
import Alamofire

public protocol BaseApi {
    static var backendConfiguration: BaseBackendConfiguration { get }
}

public extension BaseApi {
    static func command(path: String, method: HTTPMethod = .get, parameters: Parameters = [: ]) -> BaseCommand {
        return BaseCommand(path: path, backendConfiguration: backendConfiguration, method: method, parameters: parameters)
    }
}
