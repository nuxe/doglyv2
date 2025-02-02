//
//  NetworkClient.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Foundation
import Combine

// MARK: - Error Types
enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
}

// MARK: - HTTP Methods
enum HTTPMethod: String {
    case GET, POST, DELETE, PUT
}

// MARK: - NetworkClient
final class NetworkClient {
    static let shared = NetworkClient()
    private init() {}
    
    func fetch<T: Decodable>(
        urlString: String,
        method: HTTPMethod = .GET,
        body: Data? = nil,
        headers: [String: String] = [:]
    ) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .mapError { NetworkError.requestFailed($0) }
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                error is DecodingError ? NetworkError.decodingFailed(error) : error
            }
            .eraseToAnyPublisher()
    }
}
