//
//  DogListViewModelTests.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import XCTest
@testable import DoglyV2

final class DogListViewModelTests: XCTestCase {
    // MARK: - Properties
    private var sut: DogListViewModel!
    private var mockBreedService: MockBreedService!
    private var mockBreedsStream: MockBreedsStream!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockBreedService = MockBreedService()
        mockBreedsStream = MockBreedsStream()
        sut = DogListViewModel(breedService: mockBreedService, breedsStream: mockBreedsStream)
    }
    
    override func tearDown() {
        sut = nil
        mockBreedService = nil
        mockBreedsStream = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func test_fetchList_success() async {
        // Given
        let breedList = BreedList(message: ["breed1": [], "breed2": ["sub1", "sub2"]])
        mockBreedService.fetchListResult = .success(breedList)
        
        // When
        await sut.fetchList()
        
        // Then
        XCTAssertEqual(mockBreedService.fetchListCallCount, 1)
        XCTAssertEqual(mockBreedsStream.updateBreedsCallCount, 1)
        XCTAssertEqual(mockBreedsStream.lastUpdateBreedsList, breedList)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_fetchList_failure() async {
        // Given
        let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockBreedService.fetchListResult = .failure(error)
        
        // When
        await sut.fetchList()
        
        // Then
        XCTAssertEqual(mockBreedService.fetchListCallCount, 1)
        XCTAssertEqual(mockBreedsStream.updateBreedsCallCount, 0)
        XCTAssertEqual(sut.errorMessage, error.localizedDescription)
    }
    
    func test_updateFavoriteBreed() {
        // When
        sut.updateFavoriteBreed("breed1", true)
        
        // Then
        XCTAssertEqual(mockBreedsStream.updateFavoriteBreedCallCount, 1)
        XCTAssertEqual(mockBreedsStream.lastBreedName, "breed1")
        XCTAssertEqual(mockBreedsStream.lastBreedFavoriteStatus, true)
    }
    
    func test_updateFavoriteSubBreed() {
        // When
        sut.updateFavoriteSubBreed("breed1", "sub1", false)
        
        // Then
        XCTAssertEqual(mockBreedsStream.updateFavoriteSubBreedCallCount, 1)
        XCTAssertEqual(mockBreedsStream.lastBreedName, "breed1")
        XCTAssertEqual(mockBreedsStream.lastSubBreedName, "sub1")
        XCTAssertEqual(mockBreedsStream.lastSubBreedFavoriteStatus, false)
    }
    
    func test_breedsPublisher_updatesWithStreamChanges() {
        // Given
        let allBreeds = [
            Breed(name: "breed1", isFavorite: false, subBreeds: []),
            Breed(name: "breed2", isFavorite: false, subBreeds: [])
        ]
        let favoriteBreeds = [
            Breed(name: "breed1", isFavorite: true, subBreeds: [])
        ]
        
        // When
        mockBreedsStream.breedsSubject.send(allBreeds)
        mockBreedsStream.favoritesSubject.send(favoriteBreeds)
        
        // Then
        XCTAssertEqual(sut.filteredBreeds.count, 2)
        XCTAssertTrue(sut.filteredBreeds[0].isFavorite)
        XCTAssertFalse(sut.filteredBreeds[1].isFavorite)
    }
    
    func test_filteredResults_updatesWithSearchTextChanges_breedName() {
        // Given
        let allBreeds = [
            Breed(name: "breed1", isFavorite: false, subBreeds: []),
            Breed(name: "breed2", isFavorite: false, subBreeds: [])
        ]
        
        // When
        mockBreedsStream.breedsSubject.send(allBreeds)
        sut.searchText = "breed1"
        
        // Then
        XCTAssertEqual(sut.filteredBreeds.count, 1)
    }

    func test_filteredResults_updatesWithSearchTextChanges_subBreedName() {
        // Given
        let afghanSubBreed = SubBreed(name: "afghan", isFavorite: false)
        let afghanSubBreed2 = SubBreed(name: "afghan2", isFavorite: false)

        let allBreeds = [
            Breed(name: "breed1", isFavorite: false, subBreeds: [afghanSubBreed]),
            Breed(name: "breed2", isFavorite: false, subBreeds: [afghanSubBreed2]),
            Breed(name: "breed3", isFavorite: false, subBreeds: [afghanSubBreed]),
            Breed(name: "breed4", isFavorite: false, subBreeds: []),
        ]
        
        // When
        mockBreedsStream.breedsSubject.send(allBreeds)
        sut.searchText = "afghan"
        
        // Then
        XCTAssertEqual(sut.filteredBreeds.count, 3)
    }

    
}
