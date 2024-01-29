//
//  NetworkLoggerPlugin.swift
//  Safe Surfer
//
//  Created by Paul Crowley on 12/05/2020.
//  Copyright © 2020 Safe Surfer Ltd. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkLoggerPlugin: PluginType {
    
    func willSend(request: URLRequest, in command: BaseCommand) {
        
    }
    
    func didReceive(response: Alamofire.DataResponse<Any, AFError>, in command: BaseCommand) {
        printCommandDump(String(describing: command), response: response)
    }
    
    func didReceive(response: Alamofire.DataResponse<Data, AFError>, in command: BaseCommand) {
        printCommandDump(String(describing: command), response: response)
    }
}

private extension NetworkLoggerPlugin {
    func printCommandDump(_ className: String, response: Alamofire.DataResponse<Any, AFError>) {
        guard let urlRequest = response.request else { return }
        print("\n=======BEGIN \(className)========")

        print("\n\tCLASS: \(className)")
        print("\tDATE: \(Date())")

        // ---- Request ----
        print("\tREQUEST")
        if let headers = urlRequest.allHTTPHeaderFields {
            print("\t\tHEADERS")
            for (key, value) in headers {
                print("\t\t\t\(key):\(value)")
            }
        }
        print("\t\tMETHOD: \(urlRequest.httpMethod!)")
        print("\t\tURL: \(urlRequest.url?.absoluteString ?? "")")
        if let body = urlRequest.httpBody, let bodyString = String(data: body, encoding: String.Encoding.utf8) {
            print("\t\tBODY: \(bodyString)")
        }

        // ---- Response ----

        print("\n\tRESPONSE")
        if let code = response.response?.statusCode {
            print("\t\tCODE: \(code)")
        }
        if let responseValue = response.value {
            print("\t\tBODY")
            print("\t\t\t\(responseValue)")
        } else if let responseData = response.data, let responseString = String(data: responseData, encoding: .utf8) {
            print("\t\tBODY TEXT")
            print("\t\t\t\(responseString)")
        }
        if let error = response.error {
            print("\t\tERROR: \(error.localizedDescription)")
        }
        print("\n=======END \(className)========\n")
    }
    
    func printCommandDump(_ className: String, response: Alamofire.DataResponse<Data, AFError>) {
        guard let urlRequest = response.request else { return }
        print("\n=======BEGIN \(className)========")
        
        print("\n\tCLASS: \(className)")
        print("\tDATE: \(Date())")
        
        // ---- Request ----
        print("\tREQUEST")
        if let headers = urlRequest.allHTTPHeaderFields {
            print("\t\tHEADERS")
            for (key, value) in headers {
                print("\t\t\t\(key):\(value)")
            }
        }
        print("\t\tMETHOD: \(urlRequest.httpMethod!)")
        print("\t\tURL: \(urlRequest.url?.absoluteString ?? "")")
        if let body = urlRequest.httpBody, let bodyString = String(data: body, encoding: String.Encoding.utf8) {
            print("\t\tBODY: \(bodyString)")
        }
        
        // ---- Response ----
        
        print("\n\tRESPONSE")
        if let code = response.response?.statusCode {
            print("\t\tCODE: \(code)")
        }
        if let responseData = response.data, let responseString = String(data: responseData, encoding: .utf8) {
            print("\t\tBODY TEXT")
            print("\t\t\t\(responseString)")
        } else if let responseValue = response.value {
            print("\t\tBODY")
            print("\t\t\t\(responseValue)")
        }
        if let error = response.error {
            print("\t\tERROR: \(error.localizedDescription)")
        }
        print("\n=======END \(className)========\n")
    }
}
