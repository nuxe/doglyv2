//
//  BreedServiceTests.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import XCTest
import Combine
@testable import DoglyV2

final class BreedServiceTests: XCTestCase {
    private var mockNetworkClient: MockNetworkClient!
    private var breedService: BreedService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        breedService = BreedService(networkClient: mockNetworkClient)
        cancellables = []
    }
    
    func testFetchList() {
        // Given
        let expectedURL = "https://dog.ceo/api/breeds/list/all"
        let expectation = expectation(description: "Fetch breed list")
        
        // When
        breedService.fetchList()
            .sink { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            } receiveValue: { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetworkClient.lastURL, expectedURL)
        XCTAssertEqual(mockNetworkClient.lastMethod, .GET)
    }
    
    func testFetchImagesWithoutSubbreed() {
        // Given
        let breed = "hound"
        let count = 3
        let expectedURL = "https://dog.ceo/api/breed/hound/images/random/3"
        let expectation = expectation(description: "Fetch breed images")
        
        // When
        breedService.fetchImages(breed, nil, count)
            .sink { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            } receiveValue: { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetworkClient.lastURL, expectedURL)
        XCTAssertEqual(mockNetworkClient.lastMethod, .GET)
    }
    
    func testFetchImagesWithSubbreed() {
        // Given
        let breed = "hound"
        let subbreed = "afghan"
        let count = 2
        let expectedURL = "https://dog.ceo/api/breed/hound/afghan/images/random/2"
        let expectation = expectation(description: "Fetch breed images with subbreed")
        
        // When
        breedService.fetchImages(breed, subbreed, count)
            .sink { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            } receiveValue: { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockNetworkClient.lastURL, expectedURL)
        XCTAssertEqual(mockNetworkClient.lastMethod, .GET)
    }
}

// MARK: - Mock Network Client
private class MockNetworkClient: NetworkClientProtocol {
    var lastURL: String?
    var lastMethod: HTTPMethod?
    
    func fetch<T>(_ url: String, _ method: HTTPMethod, _ body: Data?, _ headers: [String : String]) -> AnyPublisher<T, Error> where T : Decodable {
        lastURL = url
        lastMethod = method
        
        // Create appropriate mock response based on the type
        let mockData: String
        if T.self == BreedList.self {
            mockData = """
            {
                "message": {"breed1": [], "breed2": ["subbreed1"]},
                "status": "success"
            }
            """
        } else if T.self == BreedImageList.self {
            mockData = """
            {
                "message": ["https://example.com/dog1.jpg"],
                "status": "success"
            }
            """
        } else {
            mockData = "{}"
        }
        
        return Just(try! JSONDecoder().decode(T.self, from: mockData.data(using: .utf8)!))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
