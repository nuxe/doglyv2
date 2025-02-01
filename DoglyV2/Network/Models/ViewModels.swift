//
//  ViewModels.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/31/25.
//

struct Breed: Hashable {
    var name: String
    var subBreeds: [SubBreed]

    var isFavorite: Bool {
        didSet {
            // Update SubBreeds
            subBreeds = subBreeds.map { subBreedData in
                var updatedSubBreed = subBreedData
                updatedSubBreed.isFavorite = isFavorite
                return updatedSubBreed
            }
        }
    }
}

struct SubBreed: Comparable, Hashable {
    let name: String
    var isFavorite: Bool
    
    static func < (lhs: SubBreed, rhs: SubBreed) -> Bool {
        lhs.name < rhs.name
    }
}

extension Breed {
    static func combineBreeds(allBreeds: [Breed], favoriteBreeds: [Breed]) -> [Breed] {
        return allBreeds.map { breed in
            var updatedBreed = breed
            
            // Update breed favorite status
            updatedBreed.isFavorite = favoriteBreeds.contains { $0.name == breed.name && $0.isFavorite }
            
            // Update subbreeds favorite status
            updatedBreed.subBreeds = breed.subBreeds.map { subBreed in
                var updatedSubBreed = subBreed
                if let matchingBreed = favoriteBreeds.first(where: { $0.name == breed.name }) {
                    updatedSubBreed.isFavorite = matchingBreed.subBreeds.contains { $0.name == subBreed.name && $0.isFavorite }
                }
                return updatedSubBreed
            }
            
            return updatedBreed
        }
    }
}
