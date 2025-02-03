//
//  MockNetworkClient.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
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
                            _ headers: [String: String]) -> AnyPublisher<T, Error> {
        fetchCallCount += 1
        lastURL = urlString
        lastMethod = method
        lastBody = body
        lastHeaders = headers
        
        return fetchResult
            .map { $0 as! T }
            .publisher
            .eraseToAnyPublisher()
    }
}
