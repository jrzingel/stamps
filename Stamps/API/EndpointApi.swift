//
//

import Foundation
import Alamofire

// Return the created commands. These can then be '.execute'ed with different callbacks depending on the appropriate conditions

public class EndpointApi: BaseApi {
    public static var backendConfiguration: BaseBackendConfiguration = Configuration()
    
    /// Ping the server for a response
    static func ping() -> BaseCommand {
        let command = self.command(path: "/ping")
        return command
    }
    
  
}
