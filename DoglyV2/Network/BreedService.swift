//
//  BreedService.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import Foundation

// MARK: - BreedServiceProtocol
protocol BreedServiceProtocol {
    func fetchList() -> AnyPublisher<BreedList, Error>
    func fetchImages(_ breed: String,
                     _ subbreed: String?,
                     _ count: Int
    ) -> AnyPublisher<BreedImageList, Error>
}

// MARK: - BreedService
class BreedService: BreedServiceProtocol {
    private static let baseURL = "https://dog.ceo/api/"

    private let networkClient: NetworkClientProtocol

    // MARK: - Initialization
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchList() -> AnyPublisher<BreedList, Error> {
        networkClient.fetch(Self.baseURL + "breeds/list/all", .GET, nil, [:])
    }
    
    func fetchImages(
        _ breed: String,
        _ subbreed: String? = nil,
        _ count: Int = 1
    ) -> AnyPublisher<BreedImageList, Error> {
        let endpoint = subbreed.map { "breed/\(breed)/\($0)" } ?? "breed/\(breed)"
        return networkClient.fetch(Self.baseURL + "\(endpoint)/images/random/\(count)", .GET, nil, [:])
    }
}
