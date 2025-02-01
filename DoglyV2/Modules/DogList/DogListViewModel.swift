//
//  DogListViewModel.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import UIKit

class DogListViewModel {

    @Published var breeds: [Breed] = []
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()

    private let favoritesStream: FavoritesStreaming
    private let breedService: BreedService

    init(
        breedService: BreedService,
        favoritesStream: FavoritesStreaming) {
        self.breedService = breedService
        self.favoritesStream = favoritesStream
        subscribeToStream()
    }
    
    func updateFavoriteBreed(_ breed: String, _ isFavorite: Bool) {
        favoritesStream.updateFavoriteBreed(breed, isFavorite)
    }
    
    func updateFavoriteSubBreed(_ subBreed: String, _ isFavorite: Bool) {
        favoritesStream.updateFavoriteSubBreed(subBreed, isFavorite)
    }
    
    func fetchList() {
        breedService
            .fetchList()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] list in
                self?.favoritesStream.updateBreeds(list)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private

    private func subscribeToStream() {
        Publishers
            .CombineLatest(favoritesStream.breeds, favoritesStream.favorites)
            .sink { [weak self] (allBreeds, favoriteBreeds) in
                    self?.breeds = Breed.combineBreeds(allBreeds: allBreeds, favoriteBreeds: favoriteBreeds)
                }
            .store(in: &cancellables)
    }
}

