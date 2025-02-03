//
//  MockDogListViewModel.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import Foundation
import Testing
@testable import DoglyV2

class MockDogListViewModel: DogListViewModelProtocol {
    var breeds: [Breed] = []
    var errorMessage: String?
    
    var updateFavoriteBreedCallCount = 0
    var lastBreedName: String?
    var lastBreedFavoriteStatus: Bool?
    
    func updateFavoriteBreed(_ breed: String, _ isFavorite: Bool) {
        updateFavoriteBreedCallCount += 1
        lastBreedName = breed
        lastBreedFavoriteStatus = isFavorite
    }
    
    var updateFavoriteSubBreedCallCount = 0
    var lastSubBreedName: String?
    var lastSubBreedFavoriteStatus: Bool?
    
    func updateFavoriteSubBreed(_ breed: String, _ subBreed: String, _ isFavorite: Bool) {
        updateFavoriteSubBreedCallCount += 1
        lastBreedName = breed
        lastSubBreedName = subBreed
        lastSubBreedFavoriteStatus = isFavorite
    }
    
    var fetchListCallCount = 0
    func fetchList() {
        fetchListCallCount += 1
    }
}
