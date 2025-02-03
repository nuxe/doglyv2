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
    
//    func testFetchImagesWithoutSubbreed() {
//        // Given
//        let breed = "hound"
//        let count = 3
//        let expectedURL = "https://dog.ceo/api/breed/hound/images/random/3"
//        let expectation = expectation(description: "Fetch breed images")
//        
//        // When
//        breedService.fetchImages(breed, nil, count)
//            .sink { completion in
//                if case .failure = completion {
//                    XCTFail("Should not fail")
//                }
//            } receiveValue: { _ in
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
//        
//        // Then
//        wait(for: [expectation], timeout: 1.0)
//        XCTAssertEqual(mockNetworkClient.lastURL, expectedURL)
//        XCTAssertEqual(mockNetworkClient.lastMethod, .GET)
//    }
    
//    func testFetchImagesWithSubbreed() {
//        // Given
//        let breed = "hound"
//        let subbreed = "afghan"
//        let count = 2
//        let expectedURL = "https://dog.ceo/api/breed/hound/afghan/images/random/2"
//        let expectation = expectation(description: "Fetch breed images with subbreed")
//        
//        // When
//        breedService.fetchImages(breed, subbreed, count)
//            .sink { completion in
//                if case .failure = completion {
//                    XCTFail("Should not fail")
//                }
//            } receiveValue: { _ in
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
//        
//        // Then
//        wait(for: [expectation], timeout: 1.0)
//        XCTAssertEqual(mockNetworkClient.lastURL, expectedURL)
//        XCTAssertEqual(mockNetworkClient.lastMethod, .GET)
//    }
}
