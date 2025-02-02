//
//  BreedService.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import Foundation

// MARK: - BreedService
class BreedService {
    private static let baseURL = "https://dog.ceo/api/"
    private let networkClient = NetworkClient.shared
    
    func fetchList() -> AnyPublisher<BreedList, Error> {
        networkClient.fetch(urlString: Self.baseURL + "breeds/list/all")
    }
    
    func fetchImages(
        _ breed: String,
        _ subbreed: String? = nil,
        _ count: Int = 1
    ) -> AnyPublisher<BreedImageList, Error> {
        let endpoint = subbreed.map { "breed/\(breed)/\($0)" } ?? "breed/\(breed)"
        return networkClient.fetch(urlString: Self.baseURL + "\(endpoint)/images/random/\(count)")
    }
}
