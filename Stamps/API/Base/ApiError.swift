//
//  ApiError.swift
//  Stamps
//
//  Created by James on 29/01/24.
//

import Foundation
import Alamofire

enum ApiError: Error {
    case badlyFormattedUrl(path: String)  // The API url cannot be parsed (compile bug)
    case badlyFormattedParameters(parameters: Parameters)
    case cannotParseResponse(parseError: Error)
    case apiRequestFailed(error: Error)
}
