//
//  NetworkController.swift
//  NextStats
//
//  Created by Jon Alaniz on 1/8/21.
//  Copyright © 2021 Jon Alaniz. All Rights Reserved.

import Foundation

enum FetchError: Error {
    case invalidData
    case missingResponse
    case network(Error)
    case unexpectedResponse(Int)

    var title: String {
        switch self {
        case .invalidData: return .localized(.invalidData)
        case .missingResponse: return .localized(.missingResponse)
        case .network(_): return .localized(.networkError)
        case .unexpectedResponse(_): return .localized(.unauthorized)
        }
    }

    var description: String {
        switch self {
        case .invalidData: return .localized(.invalidDataDescription)
        case .missingResponse: return .localized(.missingResponseDescription)
        case .network(_): return .localized(.networkError)
        case .unexpectedResponse(_): return .localized(.unexpectedResponse)
        }
    }
}

class NetworkController {
    /// Returns the singleton `NetworkController` instance
    public static let shared = NetworkController()

    private init() { }

    /// Generic network fetch
    func fetchData(with request: URLRequest,
                   using config: URLSessionConfiguration = .default,
                   completion: @escaping (Result<Data, FetchError>) -> Void) {

        var request = request
        request.setValue("NextStats for iOS", forHTTPHeaderField: "User-Agent")
        print(config.httpAdditionalHeaders)

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

            completion(.success(receivedData))
        }
        task.resume()
    }
}
