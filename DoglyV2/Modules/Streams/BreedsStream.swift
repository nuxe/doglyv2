//
//  BreedsStream.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/31/25.
//

import Combine
import SwiftUICore

protocol BreedsStreamProtocol {
    // Breeds
    var breeds: AnyPublisher<[Breed], Never> { get }
    func updateBreeds(_ list: BreedList)

    // Favorites
    var favorites: AnyPublisher<[Breed], Never> { get }
    func updateFavoriteBreed(_ breed: String, _ isFavorite: Bool)
    func updateFavoriteSubBreed(_ breed: String, _ subBreed: String, _ isFavorite: Bool)
}

class BreedsStream: BreedsStreamProtocol {
    
    // MARK: - Properties
    private let breedsSubject = CurrentValueSubject<[Breed], Never>([])
    private let favoritesSubject = CurrentValueSubject<[Breed], Never>([])
    private let favoritesStorage: FavoritesStorageProtocol
    
    // MARK: - Init
    init(favoritesStorage: FavoritesStorageProtocol) {
        self.favoritesStorage = favoritesStorage
        fetchFavoritesFromStorage()
    }
    
    // MARK: - Breeds
    var breeds: AnyPublisher<[Breed], Never> {
        breedsSubject.eraseToAnyPublisher()
    }
    
    func updateBreeds(_ list: BreedList) {
        let fetchedBreeds = convertToBreeds(from: list)
        breedsSubject.send(fetchedBreeds)
    }
    
    private func convertToBreeds(from list: BreedList) -> [Breed] {
        list.message
            .map { breedName, subBreeds in
                Breed(
                    name: breedName,
                    isFavorite: false,
                    subBreeds: subBreeds.map { createSubBreed(name: $0) }
                )
            }
            .sorted { $0.name < $1.name }
    }
    
    private func createSubBreed(name: String) -> SubBreed {
        SubBreed(name: name, isFavorite: false)
    }
    
    // MARK: - Favorites
    
    var favorites: AnyPublisher<[Breed], Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
    
    func updateFavoriteBreed(_ breed: String, _ isFavorite: Bool) {
        var currentFavorites = favoritesSubject.value
        
        if isFavorite {
            addBreedToFavorites(breed, to: &currentFavorites)
        } else {
            removeBreedFromFavorites(breed, from: &currentFavorites)
        }
        
        updateFavoritesStreamAndStorage(currentFavorites)
    }

    func updateFavoriteSubBreed(_ breed: String, _ subBreed: String, _ isFavorite: Bool) {
        guard let parentBreed = breedsSubject.value.first(where: { $0.name == breed }) else { return }
        var favorites = favoritesSubject.value
        var updatedBreed = favorites.first(where: { $0.name == parentBreed.name }) ?? parentBreed
        
        updateSubBreedFavoriteStatus(in: &updatedBreed, subBreedName: subBreed, isFavorite: isFavorite)
        updateFavoritesList(&favorites, with: updatedBreed)
        updateFavoritesStreamAndStorage(favorites)
    }
    
    // MARK: - Private

    // Breeds
    private func addBreedToFavorites(_ breedName: String, to favorites: inout [Breed]) {
        guard let breedToAdd = breedsSubject.value.first(where: { $0.name == breedName }),
              !favorites.contains(where: { $0.name == breedName && $0.isFavorite }) else { return }
        
        var updatedBreed = breedToAdd
        updatedBreed.isFavorite = true
        favorites.append(updatedBreed)
    }
    
    private func removeBreedFromFavorites(_ breedName: String, from favorites: inout [Breed]) {
        favorites.removeAll(where: { $0.name == breedName })
    }

    
    // SubBreeds
    private func updateSubBreedFavoriteStatus(in breed: inout Breed, subBreedName: String, isFavorite: Bool) {
        breed.subBreeds = breed.subBreeds.map { sub in
            var updated = sub
            if sub.name == subBreedName {
                updated.isFavorite = isFavorite
            }
            return updated
        }
    }
    
    private func updateFavoritesList(_ favorites: inout [Breed], with updatedBreed: Breed) {
        if updatedBreed.subBreeds.contains(where: { $0.isFavorite }) {
            if let index = favorites.firstIndex(where: { $0.name == updatedBreed.name }) {
                favorites[index] = updatedBreed
            } else {
                favorites.append(updatedBreed)
            }
        } else {
            favorites.removeAll(where: { $0.name == updatedBreed.name })
        }
    }
    
    // Stream and persistence
    private func updateFavoritesStreamAndStorage(_ favorites: [Breed]) {
        favoritesSubject.send(favorites)

        do {
            try favoritesStorage.saveFavorites(favorites)
        } catch {
            // TODO - Add proper error logging
            print("Failed to save to storage \(error.localizedDescription)")
        }
    }
    
    private func fetchFavoritesFromStorage() {
        do {
            let favorites = try favoritesStorage.fetchFavorites()
            favoritesSubject.send(favorites)
        } catch {
            print("Failed to fetch from storage \(error.localizedDescription)")
        }
    }
}
