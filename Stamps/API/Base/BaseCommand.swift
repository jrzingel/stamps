//
//  BaseCommand.swift
//  Stamps
//
//  Created by James on 29/01/24.
//

import Foundation
import Alamofire

public final class BaseCommand {
    internal let path: String
    internal let method: HTTPMethod
    internal let parameters: Parameters
    internal let timeout: TimeInterval
    internal let backendConfiguration: BaseBackendConfiguration
    
    internal static var id: Int64 = 0
    public static var plugins: PluginComposer = []
    public let id: Int64
    
    // Set later before calling `.execute`
    public var additionalHeaders: HTTPHeaders = [: ]
    /// Send additional data with the request with "Content-Type" being the data type. Only valid if HTTP method is POST or PUT
    public var packagedData: (Data, String)? = nil

    public init(path: String,
                backendConfiguration: BaseBackendConfiguration,
                method: HTTPMethod = .get,
                parameters: Parameters = [: ],
                timeout: TimeInterval = 60) {
        self.path = path
        self.method = method
        self.timeout = timeout
        self.backendConfiguration = backendConfiguration
        self.parameters = parameters
        
        BaseCommand.id += 1
        id = BaseCommand.id
    }
    
    
    /// Parse the response as the given object
    /// Derives from BaseCommandAsyncExecutor.execute
    func execute<Model>(completion: @escaping (Result<Model, Error>) -> Void) where Model: Decodable {
        self.fetch { responseResult in
            // Check for any errors
            switch responseResult {
            case .failure(let error): completion(.failure(ApiError.apiRequestFailed(error: error)))
            case .success(let response):
                // Send to the plugin
                BaseCommand.plugins.didReceive(response: response, in: self)
                
                switch response.result {
                case .success(let responseData):
                    
                    do {
                        let result = try JSONDecoder().decode(Model.self, from: responseData)
                        completion(.success(result))
                    } catch let error {
                        completion(.failure(ApiError.cannotParseResponse(parseError: error)))
                    }
                case .failure(let error):
                    // API request failed
                    completion(.failure(ApiError.apiRequestFailed(error: error)))
                    
                }
            }
        }
    }
    
    /// Void method when the response data is unnecessary
    public func execute(completion: @escaping (Result<Void, Error>) -> Void) {
        self.fetch { responseResult in
            switch responseResult {
            case .failure(let error): completion(.failure(ApiError.apiRequestFailed(error: error)))
            case .success(let response):
                switch response.result {
                case .success(_):
                    completion(.success)
                case .failure(let error):
                    completion(.failure(ApiError.apiRequestFailed(error: error)))
                }
            }
        }
    }
    
    
    /// Fetch the API response to the command. Call from `.execute`
    private func fetch(completion: @escaping (Result<AFDataResponse<Data>, Error>) -> Void) {
        var urlComponents = backendConfiguration.baseUrl
        urlComponents.path = path
        guard let url = urlComponents.url else {
            Logger.api.error("Cannot parse API url: \(self.path)")
            completion(.failure(ApiError.badlyFormattedUrl(path: path)))
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = method.rawValue
        
        // Add the parameters to the path
        do {
            request = try URLEncoding.default.encode(request, with: parameters)
        } catch _ {
            completion(.failure(ApiError.badlyFormattedParameters(parameters: parameters)))
            return
        }
        
        for header in backendConfiguration.defaultHeaders {
            request.setValue(header.value, forHTTPHeaderField: header.name)
        }
        
        for header in backendConfiguration.authenticationHeaders {
            request.setValue(header.value, forHTTPHeaderField: header.name)
        }
        
        for header in additionalHeaders {
            request.setValue(header.value, forHTTPHeaderField: header.name)
        }
        
        // Package the data if present
        if let packagedData = packagedData, (method == .post || method == .put) {
            request.httpBody = packagedData.0
            request.setValue(packagedData.1, forHTTPHeaderField: "Content-Type")
        }
        
        // Call any listening plugins
        // BaseCommand.plugins.willSend(request: request, in: self)
        
        AF.request(request)
            .responseData(queue: .global()) { response in
                completion(.success(response))
            }
    }
}
