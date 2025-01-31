//
//  DogListViewModel.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import UIKit

class DogListViewModel {

    @Published var breedList: BreedList?
    @Published var errorMessage: String?

    private let breedService = BreedService()
    private var cancellables = Set<AnyCancellable>()

    func fetchList() {
        breedService
            .fetchList()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] list in
                self?.breedList = list
            }
            .store(in: &cancellables)
    }
}

