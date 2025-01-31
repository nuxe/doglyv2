//
//  DogListViewModel.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import UIKit

struct SubBreedFavorite: Comparable {
    var isFavorite: Bool
    var identifier: String
    
    static func < (lhs: SubBreedFavorite, rhs: SubBreedFavorite) -> Bool {
        lhs.identifier < rhs.identifier
    }
}

struct BreedFavorite {
    var breed: String
    var isFavorite: Bool {
        get {
            if subBreeds.isEmpty {
                return false
            }
            
            return !subBreeds.contains { subBreedData in
                subBreedData.isFavorite == false
            }
        }
        set {
            subBreeds = subBreeds.map { subBreedData in
                var updatedSubBreed = subBreedData
                updatedSubBreed.isFavorite = newValue
                return updatedSubBreed
            }
        }
    }
    var subBreeds: [SubBreedFavorite]
}

class DogListViewModel {

    @Published var sections: [BreedFavorite] = []
    @Published var errorMessage: String?

    private let breedService = BreedService()
    private var cancellables = Set<AnyCancellable>()
    
    func updateFavoriteBreed(_ breed: String, _ isFavorite: Bool) {
        let updateIndex = sections.firstIndex { data in
            return data.breed == breed
        }
        guard let updateIndex else { return }
        // This will update all sub-breeds as well
        sections[updateIndex].isFavorite = isFavorite
    }
    
    func updateFavoriteSubBreed(_ subBreed: String, _ isFavorite: Bool) {
        // Find the first breed that contains this subBreed
        let updateIndex = sections.firstIndex { data in
            return data.subBreeds.contains { subBreedData in
                return subBreedData.identifier == subBreed
            }
        }
        guard let updateIndex else { return }
        
        // Update subBreeds
        let subBreeds = sections[updateIndex].subBreeds
        sections[updateIndex].subBreeds = subBreeds.map { subBreedData in
            var updatedSubBreed = subBreedData
            if subBreedData.identifier == subBreed {
                updatedSubBreed.isFavorite = isFavorite
            }
            return updatedSubBreed
        }
    }

    func fetchList() {
        breedService
            .fetchList()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] list in
                self?.sections = list.message.map({ (key: String, value: [String]) in
                    let subBreeds = value.map { subBreed in
                        SubBreedFavorite(isFavorite: false, identifier: subBreed)
                    }
                    return BreedFavorite(breed: key, subBreeds: subBreeds)
                })
                .sorted { $0.breed < $1.breed }
            }
            .store(in: &cancellables)
    }
}

