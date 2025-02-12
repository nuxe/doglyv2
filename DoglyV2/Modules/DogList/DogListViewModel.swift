//
//  DogListViewModel.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import UIKit

// MARK: - DogListViewModelProtocol
protocol DogListViewModelProtocol {
    // Published properties
    var filteredBreeds: [Breed] { get }
    var errorMessage: String? { get }
    
    // Methods
    func updateFavoriteBreed(_ breed: String, _ isFavorite: Bool)
    func updateFavoriteSubBreed(_ breed: String, _ subBreed: String, _ isFavorite: Bool)
    func fetchList() async
}

// MARK: - DogListViewModel
class DogListViewModel: NSObject, DogListViewModelProtocol {
    // MARK: - Published Properties
    private var breeds: [Breed] = []
    
    @Published var errorMessage: String?
    @Published var filteredBreeds: [Breed] = []
        
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let breedsStream: BreedsStreamProtocol
    private let breedService: BreedServiceProtocol
    
    // MARK: - Initialization
    init(breedService: BreedServiceProtocol, breedsStream: BreedsStreamProtocol) {
        self.breedService = breedService
        self.breedsStream = breedsStream
        super.init()
        subscribeToStream()
    }
    
    // MARK: - Public Methods
    func updateFavoriteBreed(_ breed: String, _ isFavorite: Bool) {
        breedsStream.updateFavoriteBreed(breed, isFavorite)
    }
    
    func updateFavoriteSubBreed(_ breed: String, _ subBreed: String, _ isFavorite: Bool) {
        breedsStream.updateFavoriteSubBreed(breed, subBreed, isFavorite)
    }
    
    func fetchList() async {
        do {
            let result = try await breedService.fetchList()
            breedsStream.updateBreeds(result)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Private Methods
    
    private func subscribeToStream() {
        Publishers.CombineLatest(breedsStream.breeds, breedsStream.favorites)
            .sink { [weak self] allBreeds, favoriteBreeds in
                let result = Breed.combineBreeds(allBreeds: allBreeds, favoriteBreeds: favoriteBreeds)
                self?.breeds = result
                self?.filteredBreeds = result
            }
            .store(in: &cancellables)
    }
}

extension DogListViewModel: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased(),
              !searchText.isEmpty else {
            filteredBreeds = breeds
            return
        }
        
        filteredBreeds = breeds.compactMap { breed in
            var result: Breed? = nil
            
            if breed.name.hasPrefix(searchText) {
                // Breed matched
                result = breed
            } else {
                // SubBreed matching
                let subBreeds = breed.subBreeds.filter { subBreed in
                    return subBreed.name.hasPrefix(searchText)
                }
                if !subBreeds.isEmpty {
                    result = Breed(name: breed.name, isFavorite: breed.isFavorite, subBreeds: subBreeds)
                }
            }
            
            return result
        }
    }
}
