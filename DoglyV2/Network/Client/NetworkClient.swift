//
//  NetworkClient.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
}

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
}

class NetworkClient {
    
    static let shared = NetworkClient() // Singleton instance

    func fetch<T: Decodable>(
        urlString: String,
        method: HTTPMethod = .GET,
        body: Data? = nil,
        headers: [String : String] = [:]
    ) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidRequest)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
