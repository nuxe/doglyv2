//
//  MockBreedsStream.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import Testing
@testable import DoglyV2

class MockBreedsStream: BreedsStreamProtocol {
    var breedsSubject = CurrentValueSubject<[Breed], Never>([])
    var favoritesSubject = CurrentValueSubject<[Breed], Never>([])
    
    var breeds: AnyPublisher<[Breed], Never> {
        breedsSubject.eraseToAnyPublisher()
    }
    
    var favorites: AnyPublisher<[Breed], Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
    
    var updateBreedsCallCount = 0
    var lastUpdateBreedsList: BreedList?
    func updateBreeds(_ list: BreedList) {
        updateBreedsCallCount += 1
        lastUpdateBreedsList = list
    }
    
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
}
