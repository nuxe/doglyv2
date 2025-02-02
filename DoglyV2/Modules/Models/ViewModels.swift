//
//  ViewModels.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/31/25.
//

protocol Favoritable {
    var name: String { get }
    var isFavorite: Bool { get }
}

// MARK: - Models
struct Breed: Hashable, Favoritable {

    // MARK: - Favoritable
    var name: String
    var isFavorite: Bool {
        didSet {
            subBreeds = subBreeds.map { subBreed in
                var updated = subBreed
                updated.isFavorite = isFavorite
                return updated
            }
        }
    }
    
    var subBreeds: [SubBreed]
}

struct SubBreed: Comparable, Hashable, Favoritable {
    // MARK: - Favoritable
    let name: String
    var isFavorite: Bool
    
    static func < (lhs: SubBreed, rhs: SubBreed) -> Bool {
        lhs.name < rhs.name
    }
}

// MARK: - Breed Helpers
extension Breed {
    static func combineBreeds(allBreeds: [Breed], favoriteBreeds: [Breed]) -> [Breed] {
        allBreeds.map { breed in
            var updated = breed
            let matchingFavorite = favoriteBreeds.first { $0.name == breed.name }
            
            updated.isFavorite = matchingFavorite?.isFavorite ?? false
            updated.subBreeds = breed.subBreeds.map { subBreed in
                var updatedSubBreed = subBreed
                updatedSubBreed.isFavorite = matchingFavorite?.subBreeds
                    .contains { $0.name == subBreed.name && $0.isFavorite } ?? false
                return updatedSubBreed
            }
            
            return updated
        }
    }
}
