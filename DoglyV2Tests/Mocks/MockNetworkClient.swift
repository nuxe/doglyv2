//
//  MockNetworkClient.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import Foundation
import Testing
@testable import DoglyV2

class MockNetworkClient: NetworkClientProtocol {
    var fetchCallCount = 0
    var lastURL: String?
    var lastMethod: HTTPMethod?
    var lastBody: Data?
    var lastHeaders: [String: String]?
    var fetchResult: Result<Any, Error> = .success([:])
    
    func fetch<T: Decodable>(_ urlString: String,
                            _ method: HTTPMethod,
                            _ body: Data?,
                            _ headers: [String: String]) async throws -> T {
        fetchCallCount += 1
        lastURL = urlString
        lastMethod = method
        lastBody = body
        lastHeaders = headers
        
        switch fetchResult {
        case .success(let value):
            guard let result = value as? T else {
                throw NetworkError.decodingFailed(NSError(domain: "Mock", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not cast mock result to expected type"]))
            }
            return result
        case .failure(let error):
            throw error
        }
    }
}
