//
//  DogDetailViewModel.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import UIKit

class DogDetailViewModel {

    @Published var breedImages: [URL] = []
    @Published var errorMessage: String?
    private var favorites: [Breed] = []

    private var cancellables = Set<AnyCancellable>()
    private var imageCancellables = Set<AnyCancellable>()

    private let breedService: BreedService
    private let favoritesStream: FavoritesStreaming

    init(
        breedService: BreedService,
        favoritesStream: FavoritesStreaming) {
        self.breedService = breedService
        self.favoritesStream = favoritesStream
        subscribeToStream()
    }
    
    func refetch() {
        fetchForFavorites(favorites)
    }
    
    // MARK: - Private
    
    private func subscribeToStream() {
        favoritesStream
            .favorites
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.errorMessage = error.localizedDescription
                default:
                    break
                }
            } receiveValue: { [weak self] favorites  in
                self?.favorites = favorites
            }
            .store(in: &cancellables)
    }
    
    private func fetchForFavorites(_ favorites: [Breed]) {
        imageCancellables.removeAll()
        
        let publishers = favorites.map { breed in
            if breed.subBreeds.isEmpty || breed.isFavorite {
                // Only fetch images for the top level breed
                return breedService
                    .fetchImages(breed.name)
                    .map { imageList in
                        imageList.message
                    }
                    .catch { error -> AnyPublisher<[URL], Never> in
                        print("Error fetching \(breed): \(error)")
                        return Just([]).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            } else {
                // Fetch images for each sub-breed that is favorited
                let subBreedPublishers = breed.subBreeds.map { subBreed in
                    breedService
                        .fetchImages(breed.name, subBreed.name)
                        .map { imageList in
                            imageList.message
                        }
                        .catch { error -> AnyPublisher<[URL], Never> in
                            print("Error fetching \(breed): \(error)")
                            return Just([]).eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                }
                return Publishers.MergeMany(subBreedPublishers)
                    .collect()
                    .map { $0.flatMap { $0 } }
                    .eraseToAnyPublisher()
            }
        }
        
        Publishers.MergeMany(publishers)
            .collect()
            .map { $0.flatMap { $0 } }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                self?.breedImages = images
            }
            .store(in: &imageCancellables)
    }
}
