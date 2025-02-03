//
//  ViewModelsTests.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import XCTest
@testable import DoglyV2

final class ViewModelsTests: XCTestCase {
    
    func testBreedFavoriteTogglePropagation() throws {
        // Test that changing breed's isFavorite updates all subBreeds
        var breed = Breed(
            name: "Terrier",
            isFavorite: false,
            subBreeds: [
                SubBreed(name: "Yorkshire", isFavorite: false),
                SubBreed(name: "Scottish", isFavorite: false)
            ]
        )
        
        breed.isFavorite = true
        XCTAssertTrue(breed.subBreeds.allSatisfy { $0.isFavorite })
    }
    
    func testSubBreedComparison() throws {
        let subBreed1 = SubBreed(name: "Yorkshire", isFavorite: false)
        let subBreed2 = SubBreed(name: "Scottish", isFavorite: false)
        
        XCTAssertTrue(subBreed2 < subBreed1) // "Scottish" comes before "Yorkshire"
    }
    
    func testCombineBreeds() throws {
        let allBreeds = [
            Breed(
                name: "Terrier",
                isFavorite: false,
                subBreeds: [
                    SubBreed(name: "Yorkshire", isFavorite: false),
                    SubBreed(name: "Scottish", isFavorite: false)
                ]
            )
        ]
        
        let favoriteBreeds = [
            Breed(
                name: "Terrier",
                isFavorite: true,
                subBreeds: [
                    SubBreed(name: "Yorkshire", isFavorite: true),
                    SubBreed(name: "Scottish", isFavorite: false)
                ]
            )
        ]
        
        let combined = Breed.combineBreeds(allBreeds: allBreeds, favoriteBreeds: favoriteBreeds)
        
        XCTAssertEqual(combined.count, 1)
        XCTAssertTrue(combined[0].isFavorite)
        XCTAssertTrue(combined[0].subBreeds[0].isFavorite) // Yorkshire should be favorite
        XCTAssertFalse(combined[0].subBreeds[1].isFavorite) // Scottish should not be favorite
    }
}
