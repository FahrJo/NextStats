//
//  NetworkController.swift
//  NextStats
//
//  Created by Jon Alaniz on 1/8/21.
//  Copyright © 2021 Jon Alaniz. All rights reserved.
//

import Foundation

enum FetchError: Error {
    case network(Error)
    case missingResponse
    case unexpectedResponse(Int)
    case invalidData
    case invalidJSON(Error)
}

enum FetchType {
    case statistics
    case authResponse
    case poll
    case serverAuthenticationInfo
}

class NetworkController {
    
    // Fetch JSON data user server credentials
    func fetchData(for server: NextServer, completion: @escaping (Result<ServerStats, FetchError>) -> Void) {
        
        // Prepare the server credentials
        let credentials = "\(server.username):\(server.password)".data(using: .utf8)!
        let encryptedCredentials = credentials.base64EncodedData()
        let authenticatonString = "Basic \(encryptedCredentials)"
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": authenticatonString]
        
        // Setup our request
        let url = URL(string: server.URLString)!
        let request = URLRequest(url: url)
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (possibleData, possibleResponse, possibleError) in
            
            guard possibleError == nil else {
                completion(.failure(.network(possibleError!)))
                return
            }
            
            guard let response = possibleResponse as? HTTPURLResponse else {
                completion(.failure(.missingResponse))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(.unexpectedResponse(response.statusCode)))
                return
            }
            
            guard let receivedData = possibleData else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(ServerStats.self, from: receivedData)
                completion(.success(result))
            } catch {
                completion(.failure(.invalidJSON(error)))
            }
        }
        task.resume()
    }
    
}
