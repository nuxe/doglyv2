//
//  BreedsStream.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/31/25.
//

import Combine
import SwiftUICore

protocol BreedsStreaming {
    // Breeds
    var breeds: AnyPublisher<[Breed], Never> { get }
    func updateBreeds(_ list: BreedList)

    // Favorites
    var favorites: AnyPublisher<[Breed], Never> { get }
    func updateFavoriteBreed(_ breed: String, _ isFavorite: Bool)
    func updateFavoriteSubBreed(_ breed: String, _ subBreed: String, _ isFavorite: Bool)
}

class BreedsStream: BreedsStreaming {
    
    // MARK: - Properties
    private let breedsSubject = CurrentValueSubject<[Breed], Never>([])
    private let favoritesSubject = CurrentValueSubject<[Breed], Never>([])
    
    // MARK: - Breeds
    var breeds: AnyPublisher<[Breed], Never> {
        breedsSubject.eraseToAnyPublisher()
    }
    
    func updateBreeds(_ list: BreedList) {
        let fetchedBreeds = list.message.map { key, value in
            Breed(
                name: key,
                isFavorite: false,
                subBreeds: value.map { SubBreed(name: $0, isFavorite: false) }
            )
        }
        .sorted { $0.name < $1.name }
        
        breedsSubject.send(fetchedBreeds)
    }
    
    // MARK: - Favorites
    
    var favorites: AnyPublisher<[Breed], Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
    
    func updateFavoriteBreed(_ breed: String, _ isFavorite: Bool) {
        var currentFavorites = favoritesSubject.value
        
        if !isFavorite {
            currentFavorites.removeAll(where: { $0.name == breed })
        } else if let breedToAdd = breedsSubject.value.first(where: { $0.name == breed }),
                  !currentFavorites.contains(where: { $0.name == breed && $0.isFavorite }) {
            var updatedBreed = breedToAdd
            updatedBreed.isFavorite = true
            currentFavorites.append(updatedBreed)
        }
        
        favoritesSubject.send(currentFavorites)
    }
    
    func updateFavoriteSubBreed(_ breed: String, _ subBreed: String, _ isFavorite: Bool) {
        guard let parentBreed = breedsSubject.value.first(where: { $0.name == breed }) else { return }
        var favorites = favoritesSubject.value
        var updatedBreed = favorites.first(where: { $0.name == parentBreed.name }) ?? parentBreed
        
        updatedBreed.subBreeds = updatedBreed.subBreeds.map { sub in
            var updated = sub
            if sub.name == subBreed {
                updated.isFavorite = isFavorite
            }
            return updated
        }
        
        if updatedBreed.subBreeds.contains(where: { $0.isFavorite }) {
            if let index = favorites.firstIndex(where: { $0.name == parentBreed.name }) {
                favorites[index] = updatedBreed
            } else {
                favorites.append(updatedBreed)
            }
        } else {
            favorites.removeAll(where: { $0.name == parentBreed.name })
        }
        
        favoritesSubject.send(favorites)
    }
}
