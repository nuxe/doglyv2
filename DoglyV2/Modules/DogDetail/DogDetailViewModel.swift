//
//  DogDetailViewModel.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import UIKit

protocol DogDetailViewModelProtocol {
    // Published properties
    var breedImages: [URL] { get }
    var errorMessage: String? { get }
    
    // Methods
    func refetch()
}

class DogDetailViewModel: DogDetailViewModelProtocol {

    // MARK: - Published Properties
    @Published var breedImages: [URL] = []
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private var favorites: [Breed] = []
    private var cancellables = Set<AnyCancellable>()
    private var imageCancellables = Set<AnyCancellable>()
    private let breedService: BreedServiceProtocol
    private let breedsStream: BreedsStreamProtocol

    // MARK: - Lifecycle
    init(
        breedService: BreedServiceProtocol,
        breedsStream: BreedsStreamProtocol
    ) {
        self.breedService = breedService
        self.breedsStream = breedsStream
        subscribeToStream()
    }
    
    // MARK: - Public Methods
    func refetch() {
        fetchForFavorites(favorites)
    }
    
    // MARK: - Private Methods
    private func subscribeToStream() {
        breedsStream.favorites
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] favorites in
                self?.favorites = favorites
            }
            .store(in: &cancellables)
    }
    
    private func fetchForFavorites(_ favorites: [Breed]) {
        imageCancellables.removeAll()
        
        let publishers = favorites.map { breed in
            fetchImagesPublisher(for: breed)
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
    
    private func fetchImagesPublisher(for breed: Breed) -> AnyPublisher<[URL], Never> {
        if breed.subBreeds.isEmpty || breed.isFavorite {
            return fetchBreedImages(breed.name)
        }
        
        let subBreedPublishers = breed.subBreeds
            .filter { $0.isFavorite }
            .compactMap { subBreed in
                fetchBreedImages(breed.name, subBreed: subBreed.name)
            }
        
        return Publishers.MergeMany(subBreedPublishers)
            .collect()
            .map { $0.flatMap { $0 } }
            .eraseToAnyPublisher()
    }
    
    private func fetchBreedImages(_ breed: String, subBreed: String? = nil) -> AnyPublisher<[URL], Never> {
        let publisher = subBreed != nil ?
            breedService.fetchImages(breed, subBreed!, 1) :
            breedService.fetchImages(breed, nil, 1)
        
        return publisher
            .map(\.message)
            .catch { error -> AnyPublisher<[URL], Never> in
                print("Error fetching \(breed): \(error)")
                return Just([]).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
