//
//  MockBreedService.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import Testing
@testable import DoglyV2

class MockBreedService: BreedServiceProtocol {
    var fetchListCallCount = 0
    var fetchListResult: Result<BreedList, Error> = .success(BreedList(message: [:]))
    
    func fetchList() async throws -> BreedList {
        fetchListCallCount += 1
        switch fetchListResult {
        case .success(let breedList):
            return breedList
        case .failure(let error):
            throw error
        }
    }
    
    var fetchImagesCallCount = 0
    var lastBreed: String?
    var lastSubBreed: String?
    var lastCount: Int?
    var fetchImagesResult: Result<BreedImageList, Error> = .success(BreedImageList(message: []))
    
    func fetchImages(_ breed: String, _ subbreed: String?, _ count: Int) async throws -> BreedImageList {
        fetchImagesCallCount += 1
        lastBreed = breed
        lastSubBreed = subbreed
        lastCount = count
        
        switch fetchImagesResult {
        case .success(let imageList):
            return imageList
        case .failure(let error):
            throw error
        }
    }
}
