//
//  MockBreedService.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import Testing
@testable import DoglyV2

class MockBreedService: BreedServiceProtocol {
    var fetchListCallCount = 0
    var fetchListResult: Result<BreedList, Error> = .success(BreedList(message: [:]))
    
    func fetchList() -> AnyPublisher<BreedList, Error> {
        fetchListCallCount += 1
        return fetchListResult.publisher.eraseToAnyPublisher()
    }
    
    var fetchImagesCallCount = 0
    var lastBreed: String?
    var lastSubBreed: String?
    var lastCount: Int?
    var fetchImagesResult: Result<BreedImageList, Error> = .success(BreedImageList(message: []))
    
    func fetchImages(_ breed: String, _ subbreed: String?, _ count: Int) -> AnyPublisher<BreedImageList, Error> {
        fetchImagesCallCount += 1
        lastBreed = breed
        lastSubBreed = subbreed
        lastCount = count
        return fetchImagesResult.publisher.eraseToAnyPublisher()
    }
}
