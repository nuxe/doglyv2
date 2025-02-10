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
    func refetch() async
    func fetchBreedImage(_ breed: String, subBreed: String?) async -> [URL]
}

class DogDetailViewModel: DogDetailViewModelProtocol, ObservableObject {

    // MARK: - Published Properties
    @Published var breedImages: [URL] = []
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private var favorites: [Breed] = []
    private var cancellables = Set<AnyCancellable>()
    private let breedService: BreedServiceProtocol
    private let breedsStream: BreedsStreamProtocol
    private var currentFetchTask: Task<Void, Never>?

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
    func refetch() async {
        currentFetchTask?.cancel()
        currentFetchTask = Task { [weak self] in
            await self?.fetchForFavorites(self?.favorites ?? [])
        }
        await currentFetchTask?.value
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
    
    private func fetchForFavorites(_ favorites: [Breed]) async {
        guard !Task.isCancelled else { return }
        
        let urls: [URL] = await withTaskGroup(of: [URL].self) { [weak self] taskGroup in
            guard let self else { return [] }
            
            for breed in favorites {
                taskGroup.addTask { await self.fetchImages(for: breed) }
            }
            
            var allUrls = [URL]()
            for await breedUrls in taskGroup {
                allUrls.append(contentsOf: breedUrls)
            }
            return allUrls
        }
        
        breedImages = urls
    }
    
    private func fetchImages(for breed: Breed) async -> [URL] {
        if breed.subBreeds.isEmpty || breed.isFavorite {
            return await fetchBreedImage(breed.name)
        }
        
        let favoritedSubBreeds = breed.subBreeds.filter { $0.isFavorite }
        
        return await withTaskGroup(of: [URL].self) { [weak self] taskGroup in
            guard let self else { return [] }
            
            for subBreed in favoritedSubBreeds {
                taskGroup.addTask {
                    await self.fetchBreedImage(breed.name, subBreed: subBreed.name)
                }
            }
            
            var allUrls = [URL]()
            for await subBreedUrls in taskGroup {
                allUrls.append(contentsOf: subBreedUrls)
            }
            return allUrls
        }
    }
    
    func fetchBreedImage(_ breed: String, subBreed: String? = nil) async -> [URL] {
        do {
            let result: BreedImageList = try await subBreed != nil ?
                breedService.fetchImages(breed, subBreed!, 1) :
                breedService.fetchImages(breed, nil, 1)
            return result.message
        } catch {
            errorMessage = "Error fetching \(breed): \(error.localizedDescription)"
            return []
        }
    }
}
