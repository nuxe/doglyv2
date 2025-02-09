//
//  BreedService.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Foundation

// MARK: - BreedServiceProtocol
protocol BreedServiceProtocol {
    func fetchList() async throws -> BreedList
    func fetchImages(_ breed: String, _ subbreed: String?, _ count: Int) async throws -> BreedImageList
}

// MARK: - BreedService
class BreedService: BreedServiceProtocol {
    private static let baseURL = "https://dog.ceo/api/"

    private let networkClient: NetworkClientProtocol

    // MARK: - Initialization
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchList() async throws -> BreedList {
        let result: BreedList = try await networkClient.fetch(Self.baseURL + "breeds/list/all", .GET, nil, [:])
        return result
    }
    
    func fetchImages(_ breed: String, _ subbreed: String? = nil, _ count: Int = 1) async throws -> BreedImageList {
        let endpoint = subbreed.map { "breed/\(breed)/\($0)" } ?? "breed/\(breed)"
        
        let result: BreedImageList = try await networkClient.fetch(Self.baseURL + "\(endpoint)/images/random/\(count)", .GET, nil, [:])
        return result
    }
}
