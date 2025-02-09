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

// MARK: - NetworkClientProtocol
protocol NetworkClientProtocol {
    func fetch<T: Decodable>(_ urlString: String,
                             _ method: HTTPMethod,
                             _ body: Data?,
                             _ headers: [String: String]) async throws -> T
}

// MARK: - NetworkClient
final class NetworkClient: NetworkClientProtocol {
    
    func fetch<T: Decodable>(_ urlString: String,
                             _ method: HTTPMethod = .GET,
                             _ body: Data? = nil,
                             _ headers: [String: String] = [:]
    ) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidRequest
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(T.self, from: data)

        return decoded
    }
}
