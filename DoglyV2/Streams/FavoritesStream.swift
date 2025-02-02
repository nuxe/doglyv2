//
//  FavoritesStream.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/31/25.
//

import Combine
import SwiftUICore

protocol FavoritesStreaming {
    // Breeds
    var breeds: AnyPublisher<[Breed], Never> { get }
    func updateBreeds(_ list: BreedList)

    // Favorites
    var favorites: AnyPublisher<[Breed], Never> { get }
    func updateFavoriteBreed(_ breed: String, _ isFavorite: Bool)
    func updateFavoriteSubBreed(_ breed: String,_ subBreed: String, _ isFavorite: Bool)
}

class FavoritesStream: FavoritesStreaming {
    
    private let breedsSubject: CurrentValueSubject<[Breed], Never>
    
    private let favoritesSubject: CurrentValueSubject<[Breed], Never>
    
    init() {
        self.breedsSubject = CurrentValueSubject([])
        self.favoritesSubject = CurrentValueSubject([])
    }

    // Breeds

    var breeds: AnyPublisher<[Breed], Never> {
        return breedsSubject.eraseToAnyPublisher()
    }

    func updateBreeds(_ list: BreedList) {
        let fetchedBreeds = list.message.map({ (key: String, value: [String]) in
            let subBreeds = value.map { subBreed in
                SubBreed(name: subBreed, isFavorite: false)
            }
            return Breed(name: key, subBreeds: subBreeds, isFavorite: false)
        })
        .sorted { $0.name < $1.name }

        breedsSubject.send(fetchedBreeds)
    }
    
    // Favorites
    
    var favorites: AnyPublisher<[Breed], Never> {
        return favoritesSubject.eraseToAnyPublisher()
    }
    
    func updateFavoriteBreed(_ breed: String, _ isFavorite: Bool) {
        var currentFavorites = favoritesSubject.value
        let index = currentFavorites.firstIndex(where: { $0.name == breed })
        
        if !isFavorite {
            // Remove breed from favorites if it exists
            currentFavorites.removeAll(where: { $0.name == breed })
        } else if !currentFavorites.contains(where: { $0.name == breed && $0.isFavorite }) {
            // Add to favorites if not already present
            if let breedToAdd = breedsSubject.value.first(where: { $0.name == breed }) {
                var updatedBreed = breedToAdd
                updatedBreed.isFavorite = true
                currentFavorites.append(updatedBreed)
            }
        }
        
        favoritesSubject.send(currentFavorites)
    }
    
    func updateFavoriteSubBreed(_ breed: String,_ subBreed: String, _ isFavorite: Bool) {
        // Find the parent breed from all breeds
        guard let parentBreed = breedsSubject.value.first(where: { $0.name == breed }) else { return }

        var favorites = favoritesSubject.value

        // Get or create the breed in favorites, preserving existing favorite states
        var updatedBreed = favorites.first(where: { $0.name == parentBreed.name }) ?? parentBreed

        // Update state of specific sub-breed
        updatedBreed.subBreeds = updatedBreed.subBreeds.map { sub in
            var updated = sub
            if sub.name == subBreed {
                updated.isFavorite = isFavorite
            }
            return updated
        }
        
        // Update favorites list
        if updatedBreed.subBreeds.contains(where: { $0.isFavorite} ) {
            // Sub-breeds have at least one which is a favorite
            if let index = favorites.firstIndex(where: {$0.name == parentBreed.name} ) {
                // Was already in favorites
                favorites[index] = updatedBreed
            } else {
                // Was not yet in favorites
                favorites.append(updatedBreed)
            }
        } else {
            // Does not contain even a single favorite subbreed
            favorites.removeAll(where: { $0.name == parentBreed.name })
        }
        
        favoritesSubject.send(favorites)
    }
}
