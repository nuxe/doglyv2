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
    private var favorites: [String] = []

    private var cancellables = Set<AnyCancellable>()
    
    private let breedService: BreedService
    private let favoritesStream: FavoritesStreaming

    init(
        breedService: BreedService,
        favoritesStream: FavoritesStreaming) {
        self.breedService = breedService
        self.favoritesStream = favoritesStream
            
        favoritesStream
            .breeds
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.errorMessage = error.localizedDescription
                default:
                    break
                }
            } receiveValue: { [weak self] breeds  in
                self?.fetchForFavorites(breeds)
            }
            .store(in: &cancellables)
    }

    private func fetchForFavorites(_ breeds: [Breed]) {
        // TODO: Should we empty out cancellables here?
        let publishers = breeds.map { breed in
            breedService
                .fetchImages(breed.name)
                .map { imageList in
                    imageList.message
                }
                .catch { error -> AnyPublisher<[URL], Never> in
                    print("Error fetching \(breed): \(error)")
                    return Just([]).eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
        
        Publishers
            .MergeMany(publishers)
            .collect()
            .sink { [weak self] results in
                let allUrls = results.flatMap { $0 }
                self?.breedImages = allUrls
            }
            .store(in: &cancellables)
    }
}
