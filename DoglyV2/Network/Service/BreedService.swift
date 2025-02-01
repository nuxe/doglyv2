//
//  BreedService.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import Foundation

class BreedService {
    
    private static let baseURL: String = "https://dog.ceo/api/"
    
    let networkClient = NetworkClient.shared
    
    func fetchList() -> AnyPublisher<BreedList, Error> {
        networkClient
            .fetch(urlString: BreedService.baseURL + "breeds/list/all")
    }
    
    func fetchImages(
        _ breed: String,
        _ subbreed: String? = nil,
        _ count: Int = 1
    ) -> AnyPublisher<BreedImageList, Error> {
        var urlString: String = BreedService.baseURL + "breed/\(breed)/images/random/\(count)"
        
        if let subbreed {
            urlString = "breed/\(breed)/\(subbreed)/images/random/\(count)"
        }

        return networkClient.fetch(urlString: urlString)
    }
}
