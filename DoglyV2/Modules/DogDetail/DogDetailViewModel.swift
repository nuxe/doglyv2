//
//  DogDetailViewModel.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import UIKit

class DogDetailViewModel {

    @Published var breedImages: BreedImageList?
    @Published var errorMessage: String?

    private let breedService = BreedService()
    private var cancellables = Set<AnyCancellable>()

    func fetchImages(
        _ breed: String = "corgi",
        _ subbreed: String? = nil,
        _ count: Int = 3
    ) {
        breedService
            .fetchImages(breed, subbreed, count)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] images in
                self?.breedImages = images
            }
            .store(in: &cancellables)
    }
}
