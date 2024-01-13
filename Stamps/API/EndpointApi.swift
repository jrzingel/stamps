//
//

import Foundation
import Alamofire

// Return the created commands. These can then be '.execute'ed with different callbacks depending on the appropriate conditions

enum ApiError: Error {
    case cannotParseResponse(error: Error)
}

public class EndpointApi: BaseApi {
    static let decoder = JSONDecoder()
    
    public static var configuration: BaseConfiguration = Configuration()
    
    static func ping(completion: @escaping(Result<Bool, AFError>) -> Void) {
        self.command(path: "/ping").execute { result in
            switch result {
            case .failure(let failure):
                completion(.failure(failure))
            case .success(let data):
                print(data)
                completion(.success(true))
            }
        }
    }
    
    /// Get the last log. Migrate away from using this to instead requesting the stamps in batch
    static func getLastLog(completion: @escaping(Result<Stamp, Error>) -> Void) {
        self.command(path: "/v2/log/last").execute { result in
            switch result {
            case .failure(let error): completion(.failure(error))
            case .success(let response):
                print("API response '\(response)'")
                do {
                    let rawLog = try decoder.decode(RawStamp.self, from: Data(response.utf8))
                    completion(.success(Stamp(from: rawLog, lastSynced: Date())))
                } catch {
                    completion(.failure(ApiError.cannotParseResponse(error: error)))
                }
            }
            
        }
    }
    
    /// Get the last `n: Int` stamps.
    /// Eventually upgrade this to get stamps based on any query / feature
    static func getLastNLogs(num: Int, completion: @escaping(Result<[Stamp], Error>) -> Void) {
        let params = ["num": num]
        self.command(path: "/v2/log/recent", parameters: params).execute { result in
            switch result {
            case .failure(let error): completion(.failure(error))
            case .success(let response):
                print("API response \(response)")
                do {
                    let rawLogs = try decoder.decode([RawStamp].self, from: Data(response.utf8))
                    var stamps = [Stamp]()
                    for rawLog in rawLogs {
                        stamps.append(Stamp(from: rawLog, lastSynced: Date()))
                    }
                    completion(.success(stamps))
                } catch {
                    completion(.failure(ApiError.cannotParseResponse(error: error)))
                }
            }
        }
    }
}

    /*
    static func register(email: String, password: String, createAccount: Bool, deviceName: String, deviceType: SSDevice.`Type`, deviceOS: String) -> BaseCommand {
        let command = self.command(path: "v2/device-registration", method: .post, parameters: ["email": email, "password": password, "createAccount": createAccount ? "true" : "false", "deviceType": deviceType.rawValue, "deviceName": deviceName, "deviceOS": deviceOS])
        
        command.isAuthorised = false
        return command
    }
    
    static func registerDevice(type: SSDevice.`Type`, name: String, os: String) -> BaseCommand {
        let command = self.command(path: "devices", method: .post, parameters: ["type": type.rawValue, "name": name, "os": os])
        command.isAuthorised = false
        
        return command
    }
    
    static func getDNSToken(for deviceId: String) -> BaseCommand {
        let command = self.command(path: "devices/device/\(deviceId)/dns-token")
        
        return command
    }
    
    static func signin(email: String, password: String, deviceId: String?) -> BaseCommand {
        var parameters: [String: Any] = ["email": email, "password": password]
        if let deviceId = deviceId {
            parameters["deviceID"] = deviceId
        }
        let command = self.command(path: "user/auth", method: .post, parameters: parameters)
        command.isAuthorised = false
        
        return command
    }
    
    static func signup(email: String, password: String) -> BaseCommand {
        let command =  self.command(path: "user", method: .post, parameters: ["email": email, "password": password])
        command.isAuthorised = false
        
        return command
    }
    
    static func checkAuth() -> BaseCommand {
        let command =  self.command(path: "user/auth")
        command.shouldLogoutIfSessionFailed = false
        
        return command
    }
    
    static func startScreencat() -> BaseCommand {
        let command =  self.command(path: "screencasts/cast", method: .post)
        
        return command
    }
    
    static func stopScreencast() -> BaseCommand {
        let command =  self.command(path: "screencasts/cast/stop", method: .post)
        
        return command
    }
    
    static func refreshSubscriptionInfo() -> BaseCommand {
        let command =  self.command(path: "user/subscriptions/refresh-jwt", method: .get)
        
        return command
    }
    
    static func addScreenCastEvent(screencastId: Int64, timestamp: Int64, levels: Data, category: String, image: Data?) throws -> BaseCommand {
    
        let data = MultipartFormData()
        data.append("\(timestamp)".data(using: .utf8)!, withName: "timestamp")
        data.append(levels, withName: "levels")
        data.append(category.data(using: .utf8)!, withName: "category")
        
        if let image = image {
            data.append(image, withName: "image", fileName: "image", mimeType: "image/jpeg")
        }

        let encodedData = try data.encode()
        
        return command(path: "screencasts/cast/\(screencastId)/events/event", method: .post, parameters: .data(encodedData, "multipart/form-data; boundary=\(data.boundary)"))
        
    }
    
    static func checkEmail() -> BaseCommand {
        let command = self.command(path: "v2/user/email")
        command.shouldLogoutIfSessionFailed = false
        
        return command
    }
    
    
    static func deleteAccount(email: String) -> BaseCommand {
        let command = self.command(path: "v2/user", method: .delete, parameters: ["email": email])
        command.shouldLogoutIfSessionFailed = false
        
        return command
    }
     */
