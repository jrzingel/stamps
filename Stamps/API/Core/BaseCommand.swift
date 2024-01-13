//
//  BaseCommand.swift
//  Safe Surfer
//
//  Created by Paul Crowley on 12/05/2020.
//  Copyright © 2020 Safe Surfer Ltd. All rights reserved.
//

import Foundation
import Alamofire

public final class BaseCommand {
    internal let path: String
    internal let method: Alamofire.HTTPMethod
    internal let apiConfiguration: BaseConfiguration
    public var headers: HTTPHeaders = [: ]
    public var parameters: Parameters
    
    internal static var id: Int64 = 0
    public let id: Int64  // Keep track of how many commands have been executed
    
    public init(path: String,
                apiConfiguration: BaseConfiguration,
                method: Alamofire.HTTPMethod = .get,
                parameters: Parameters = [: ]) {
        self.path = path
        self.method = method
        self.apiConfiguration = apiConfiguration
        self.parameters = parameters
        
        BaseCommand.id += 1
        id = BaseCommand.id
    }
    
    public func execute(completion: @escaping(Result<String, AFError>) -> Void) {
        var request = apiConfiguration.baseUrl
        request.path = path
        if let url = request.url {
            print(url)
            AF.request(url,
                       method: method,
                       parameters: parameters,
                       headers: apiConfiguration.authenticationHeaders)
            .responseString { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error): completion(.failure(error))
                }
            }
        } else {
            completion(.failure(AFError.invalidURL(url: request)))
        }
    }
}
