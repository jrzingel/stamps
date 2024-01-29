//
//  PluginType.swift
//  Stamps
//
//  Created by James on 29/01/24.
//

import Foundation
import Alamofire

public protocol PluginType {
    func willSend(request: URLRequest, in command: BaseCommand)
    func didReceive(response: Alamofire.DataResponse<Any, AFError>, in command: BaseCommand)
    func didReceive(response: Alamofire.DataResponse<Data, AFError>, in command: BaseCommand)
}

public struct PluginComposer: ExpressibleByArrayLiteral {
    internal let plugins: [PluginType]

    public init(arrayLiteral elements: PluginType...) {
        plugins = elements
    }
}

extension PluginComposer: PluginType {
    public func willSend(request: URLRequest, in command: BaseCommand) {
        plugins.forEach { $0.willSend(request: request, in: command) }
    }

    public func didReceive(response: Alamofire.DataResponse<Any, AFError>, in command: BaseCommand) {
        plugins.forEach { $0.didReceive(response: response, in: command) }
    }
    
    public func didReceive(response: DataResponse<Data, AFError>, in command: BaseCommand) {
        plugins.forEach { $0.didReceive(response: response, in: command) }
    }
}
