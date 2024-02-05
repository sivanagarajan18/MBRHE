//
//  APIServices.swift
//  MBRHE
//
//  Created by VC on 03/02/24.
//

import Foundation
import SystemConfiguration

let baseURL = "https://gorest.co.in/public/v2/"
let authToken = "df0ac36cd8340d90654641f2d3646a7b85ee624caee43c3bb99cde9a09507b9e"

class APIService: NSObject, URLSessionDelegate {
    
    enum RequestMethods: String {
        case get = "GET"
        case post = "POST"
    }
    
    func session() -> URLSession {
        return URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    class func request<T: Codable>(endpoints: EndPoints, parameters: String?  = nil, method: RequestMethods, completion: @escaping (Result<T, Error>, Data?) -> Void){
        guard isConnectedToNetwork() else {
            completion(.failure("Internet Not Connected"), nil)
            return
        }
        guard let url = URL(string: baseURL + endpoints.rawValue) else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        if let postData = parameters?.data(using: .utf8) {
            urlRequest.httpBody = postData
        }
        let session = session(APIService())
        let dataTask = session().dataTask(with: urlRequest) { data, response, error in
            if let err = error {
                completion(.failure(err), nil)
                print(err.localizedDescription)
                return
            }
            guard response != nil, let data = data else {
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseObject), nil)
                }
            }
            catch {
                do
                {
                    let response = try JSONDecoder().decode([ErrorField].self, from: data)
                    DispatchQueue.main.async {
                        completion(.failure("\(response.first!.field!) - \(response.first!.message!)"), nil)
                    }
                } catch {
                    completion(.failure(error), data)
                }
            }
        }
        dataTask.resume()
    }
}

func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    if flags.isEmpty {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}
enum customError: Error {
    case notConnected
}
enum EndPoints: String {
    case Users = "users"
}
extension String: Error {}
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
