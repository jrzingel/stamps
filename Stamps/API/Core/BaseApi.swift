//
//  BaseApi.swift
//  Safe Surfer
//
//  Created by Paul Crowley on 12/05/2020.
//  Copyright © 2020 Safe Surfer Ltd. All rights reserved.
//

import Foundation
import Alamofire

public protocol BaseApi {
    static var configuration: BaseConfiguration { get }
}

public extension BaseApi {
    static func command(path: String, method: Alamofire.HTTPMethod = .get, parameters: Parameters = [:]) -> BaseCommand {
        
        return BaseCommand(path: path,
                           apiConfiguration: Self.configuration,
                           method: method,
                           parameters: parameters)
    }
}
