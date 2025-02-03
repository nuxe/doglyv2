//
//  BreedsStreamTests.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import XCTest
import Combine
@testable import DoglyV2

final class BreedsStreamTests: XCTestCase {
    private var sut: BreedsStream!
    private var mockStorage: MockFavoritesStorage!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockStorage = MockFavoritesStorage()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockStorage = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Init Tests
    
    func test_init_fetchesFavoritesFromStorage() {
        let expectedBreeds = [Breed(name: "test", isFavorite: true, subBreeds: [])]
        mockStorage.fetchFavoritesResult = .success(expectedBreeds)
        
        sut = BreedsStream(favoritesStorage: mockStorage)
        
        XCTAssertEqual(mockStorage.fetchFavoritesCallCount, 1)
        
        let expectation = expectation(description: "Wait for favorites")
        var receivedBreeds: [Breed]?
        
        sut.favorites
            .first()
            .sink { breeds in
                receivedBreeds = breeds
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedBreeds, expectedBreeds)
    }
    
    // MARK: - Breeds Tests
    
    func test_updateBreeds_convertsAndPublishesBreeds() {
        sut = BreedsStream(favoritesStorage: mockStorage)
        let breedList = BreedList(message: ["husky": [], "labrador": ["yellow", "black"]])
        let expectation = expectation(description: "Wait for breeds")
        var receivedBreeds: [Breed]?
        
        sut.breeds
            .dropFirst()
            .first()
            .sink { breeds in
                receivedBreeds = breeds
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.updateBreeds(breedList)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(receivedBreeds?.count, 2)
        XCTAssertEqual(receivedBreeds?.first?.name, "husky")
        XCTAssertEqual(receivedBreeds?.last?.name, "labrador")
        XCTAssertEqual(receivedBreeds?.last?.subBreeds.count, 2)
    }
    
    // MARK: - Favorites Tests
    
    func test_updateFavoriteBreed_whenAddingFavorite() {
        sut = BreedsStream(favoritesStorage: mockStorage)  // Add sut initialization
        let breedList = BreedList(message: ["husky": []])
        sut.updateBreeds(breedList)
        
        let expectation = expectation(description: "Wait for favorites")
        var receivedBreeds: [Breed]?
        
        sut.favorites
            .dropFirst()  // Drop initial empty value
            .first()      // Take only first emission after adding favorite
            .sink { breeds in
                receivedBreeds = breeds
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.updateFavoriteBreed("husky", true)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(receivedBreeds?.count, 1)
        XCTAssertEqual(receivedBreeds?.first?.name, "husky")
        XCTAssertTrue(receivedBreeds?.first?.isFavorite ?? false)
        XCTAssertEqual(mockStorage.saveFavoritesCallCount, 1)
    }
    
    func test_updateFavoriteBreed_whenRemovingFavorite() {
        sut = BreedsStream(favoritesStorage: mockStorage)
        // First add a favorite
        let breedList = BreedList(message: ["husky": []])
        sut.updateBreeds(breedList)
        sut.updateFavoriteBreed("husky", true)
        
        let expectation = expectation(description: "Wait for favorites")
        var receivedBreeds: [Breed]?
        
        sut.favorites
            .dropFirst()
            .first()
            .sink { breeds in
                receivedBreeds = breeds
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.updateFavoriteBreed("husky", false)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertTrue(receivedBreeds?.isEmpty ?? false)
        XCTAssertEqual(mockStorage.saveFavoritesCallCount, 2)
    }
    
    func test_updateFavoriteSubBreed() {
        sut = BreedsStream(favoritesStorage: mockStorage)  // Add sut initialization
        let breedList = BreedList(message: ["labrador": ["yellow", "black"]])
        sut.updateBreeds(breedList)
        
        let expectation = expectation(description: "Wait for favorites")
        var receivedBreeds: [Breed]?
        
        sut.favorites
            .dropFirst()  // Drop initial empty value
            .first()      // Take only first emission after adding favorite
            .sink { breeds in
                receivedBreeds = breeds
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.updateFavoriteSubBreed("labrador", "yellow", true)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(receivedBreeds?.count, 1)
        XCTAssertEqual(receivedBreeds?.first?.name, "labrador")
        XCTAssertTrue(receivedBreeds?.first?.subBreeds.first(where: { $0.name == "yellow" })?.isFavorite ?? false)
        XCTAssertFalse(receivedBreeds?.first?.subBreeds.first(where: { $0.name == "black" })?.isFavorite ?? true)
        XCTAssertEqual(mockStorage.saveFavoritesCallCount, 1)
    }
}
