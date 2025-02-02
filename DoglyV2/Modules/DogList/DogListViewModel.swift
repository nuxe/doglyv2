//
//  DogListViewModel.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import UIKit

// MARK: - DogListViewModel
class DogListViewModel {
    // MARK: - Published Properties
    @Published var breeds: [Breed] = []
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let breedsStream: BreedsStreaming
    private let breedService: BreedService
    
    // MARK: - Initialization
    init(breedService: BreedService, breedsStream: BreedsStreaming) {
        self.breedService = breedService
        self.breedsStream = breedsStream
        subscribeToStream()
    }
    
    // MARK: - Public Methods
    func updateFavoriteBreed(_ breed: String, _ isFavorite: Bool) {
        breedsStream.updateFavoriteBreed(breed, isFavorite)
    }
    
    func updateFavoriteSubBreed(_ breed: String, _ subBreed: String, _ isFavorite: Bool) {
        breedsStream.updateFavoriteSubBreed(breed, subBreed, isFavorite)
    }
    
    func fetchList() {
        breedService.fetchList()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] list in
                self?.breedsStream.updateBreeds(list)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func subscribeToStream() {
        Publishers.CombineLatest(breedsStream.breeds, breedsStream.favorites)
            .sink { [weak self] allBreeds, favoriteBreeds in
                self?.breeds = Breed.combineBreeds(allBreeds: allBreeds, favoriteBreeds: favoriteBreeds)
            }
            .store(in: &cancellables)
    }
}

