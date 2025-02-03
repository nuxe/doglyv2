//
//  MockFavoritesStorage.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import Testing
@testable import DoglyV2

class MockFavoritesStorage: FavoritesStorageProtocol {
    var saveFavoritesCallCount = 0
    var lastSavedBreeds: [Breed]?
    var saveFavoritesError: Error?
    
    func saveFavorites(_ breeds: [Breed]) throws {
        saveFavoritesCallCount += 1
        lastSavedBreeds = breeds
        if let error = saveFavoritesError {
            throw error
        }
    }
    
    var fetchFavoritesCallCount = 0
    var fetchFavoritesResult: Result<[Breed], Error> = .success([])
    
    func fetchFavorites() throws -> [Breed] {
        fetchFavoritesCallCount += 1
        switch fetchFavoritesResult {
        case .success(let breeds):
            return breeds
        case .failure(let error):
            throw error
        }
    }
}
