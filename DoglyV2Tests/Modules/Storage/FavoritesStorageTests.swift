//
//  FavoritesStorageTests.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import XCTest
@testable import DoglyV2

final class FavoritesStorageTests: XCTestCase {

    var storage: FavoritesStorage!
    var testFileURL: URL!
    
    override func setUp() {
        super.setUp()
        storage = FavoritesStorage()
        
        // Get test file URL in temporary directory
        let tempDir = FileManager.default.temporaryDirectory
        testFileURL = tempDir.appendingPathComponent("favorites.json")
    }
    
    override func tearDown() {
        // Clean up test file after each test
        try? FileManager.default.removeItem(at: testFileURL)
        storage = nil
        testFileURL = nil
        super.tearDown()
    }
    
    func testSaveAndFetchFavorites() throws {
        // Arrange
        let breeds = [
            Breed(name: "Terrier", isFavorite: true, subBreeds: [
                SubBreed(name: "Yorkshire", isFavorite: true),
                SubBreed(name: "Scottish", isFavorite: false)
            ])
        ]
        
        // Act
        try storage.saveFavorites(breeds)
        let fetchedBreeds = try storage.fetchFavorites()
        
        // Assert
        XCTAssertEqual(fetchedBreeds.count, breeds.count)
        XCTAssertEqual(fetchedBreeds[0].name, breeds[0].name)
        XCTAssertEqual(fetchedBreeds[0].isFavorite, breeds[0].isFavorite)
        XCTAssertEqual(fetchedBreeds[0].subBreeds.count, breeds[0].subBreeds.count)
        XCTAssertEqual(fetchedBreeds[0].subBreeds[0].name, breeds[0].subBreeds[0].name)
        XCTAssertEqual(fetchedBreeds[0].subBreeds[0].isFavorite, breeds[0].subBreeds[0].isFavorite)
    }
    
    func testSaveFavoritesWithEmptyArray() throws {
        // Arrange
        let emptyBreeds: [Breed] = []
        
        // Act
        try storage.saveFavorites(emptyBreeds)
        let fetchedBreeds = try storage.fetchFavorites()
        
        // Assert
        XCTAssertEqual(fetchedBreeds.count, 0)
    }
}
