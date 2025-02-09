//
//  DogDetailViewModelTests.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import XCTest
@testable import DoglyV2

final class DogDetailViewModelTests: XCTestCase {
    // MARK: - Properties
    private var sut: DogDetailViewModel!
    private var breedService: MockBreedService!
    private var breedsStream: MockBreedsStream!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        breedService = MockBreedService()
        breedsStream = MockBreedsStream()
        sut = DogDetailViewModel(breedService: breedService, breedsStream: breedsStream)
    }
    
    override func tearDown() {
        sut = nil
        breedService = nil
        breedsStream = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func test_init_subscribesToFavoritesStream() {
        // Given
        let favorites = [Breed(name: "test", isFavorite: true, subBreeds: [])]
        
        // When
        breedsStream.favoritesSubject.send(favorites)
        
        // Then
        XCTAssertEqual(sut.breedImages, [])
    }
    
    func test_refetch_fetchesImagesForFavoriteBreeds() async {
        // Given
        let testURL = URL(string: "https://example.com/dog.jpg")!
        let favorites = [Breed(name: "test", isFavorite: true, subBreeds: [])]
        breedService.fetchImagesResult = .success(BreedImageList(message: [testURL]))
        breedsStream.favoritesSubject.send(favorites)
        
        // When
        await sut.refetch()
        
        // Then
        XCTAssertEqual(breedService.fetchImagesCallCount, 1)
        XCTAssertEqual(breedService.lastBreed, "test")
        XCTAssertEqual(breedService.lastCount, 1)
        XCTAssertNil(breedService.lastSubBreed)
        XCTAssertEqual(sut.breedImages, [testURL])
    }
    
    func test_fetchImages_handlesSubBreeds() async {
        // Given
        let testURL = URL(string: "https://example.com/dog.jpg")!
        let subBreed = SubBreed(name: "sub", isFavorite: true)
        let breed = Breed(name: "test", isFavorite: false, subBreeds: [subBreed])
        breedService.fetchImagesResult = .success(BreedImageList(message: [testURL]))
        breedsStream.favoritesSubject.send([breed])
        
        // When
        await sut.refetch()
        
        // Then
        XCTAssertEqual(breedService.fetchImagesCallCount, 1)
        XCTAssertEqual(breedService.lastBreed, "test")
        XCTAssertEqual(breedService.lastSubBreed, "sub")
        XCTAssertEqual(breedService.lastCount, 1)
        XCTAssertEqual(sut.breedImages, [testURL])
    }
    
    func test_fetchImages_handlesErrors() async {
        // Given
        struct TestError: Error {}
        let favorites = [Breed(name: "test", isFavorite: true, subBreeds: [])]
        breedService.fetchImagesResult = .failure(TestError())
        breedsStream.favoritesSubject.send(favorites)
        
        // When
        await sut.refetch()
        
        // Then
        XCTAssertEqual(sut.breedImages, [])
        XCTAssertNotNil(sut.errorMessage)
    }
}
