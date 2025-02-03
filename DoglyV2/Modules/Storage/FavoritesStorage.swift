//
//  FavoritesStorage.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 2/2/25.
//

import Foundation

protocol FavoritesStorageProtocol {
    func saveFavorites(_ breeds: [Breed]) throws
    func fetchFavorites() throws -> [Breed]
}

class FavoritesStorage: FavoritesStorageProtocol {
    private let fileName = "favorites.json"
    
    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }
        
    func saveFavorites(_ breeds: [Breed]) throws {
        let data = try JSONEncoder().encode(breeds)
        try data.write(to: fileURL)
    }
    
    func fetchFavorites() throws -> [Breed] {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([Breed].self, from: data)
    }
}
