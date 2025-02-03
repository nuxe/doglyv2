//
//  NetworkClientTests.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import XCTest
import Combine
@testable import DoglyV2

final class NetworkClientTests: XCTestCase {
    private var sut: NetworkClient!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = NetworkClient()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Test Helpers
    
    private struct MockResponse: Codable, Equatable {
        let id: Int
        let message: String
    }
    
    // MARK: - Tests
    
    func testFetch_WithValidURL_SuccessfulResponse() {
        // Given
        let expectation = expectation(description: "Fetch completion")
        let mockResponse = MockResponse(id: 1, message: "Success")
        let mockData = try! JSONEncoder().encode(mockResponse)
        let mockURL = "https://api.example.com/test"
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        var receivedResponse: MockResponse?
        var receivedError: Error?
        
        // When
        sut.fetch(mockURL)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { (response: MockResponse) in
                    receivedResponse = response
                }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedResponse, mockResponse)
    }
    
    func testFetch_WithInvalidURL_ReturnsError() {
        // Given
        let expectation = expectation(description: "Fetch completion")
        let invalidURL = ""
        
        var receivedError: Error?
        
        // When
        sut.fetch(invalidURL)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { (response: MockResponse) in
                    XCTFail("Should not receive value for invalid URL")
                }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedError)
        XCTAssertTrue(receivedError is NetworkError)
        if let networkError = receivedError as? NetworkError {
            XCTAssertEqual(String(describing: networkError), String(describing: NetworkError.invalidRequest))
        }
    }
}

// MARK: - MockURLProtocol
private class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Handler is unavailable.")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
