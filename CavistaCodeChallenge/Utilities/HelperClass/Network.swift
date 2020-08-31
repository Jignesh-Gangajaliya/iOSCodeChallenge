//
//  Created by CavistaCodeChallenge
//  Copyright © CavistaCodeChallenge All rights reserved.
//  Created on 30/08/20

import Alamofire
import UIKit

struct AlamofireManager {
    static let shared: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60.0 // Seconds
        configuration.timeoutIntervalForResource = 60.0 // Seconds
        return Alamofire.Session(configuration: configuration)
    }()
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class Network {
    
    /// Request Call
    /// - Parameters:
    ///   - url: pass url
    ///   - callback: callback description
    class func request(url: String, callback: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(url).responseJSON { response in
            switch(response.result) {
            case .success(let data):
                print(data)
                callback(.success(response.data))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
