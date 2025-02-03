//
//  NetworkModels.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Foundation

// MARK: - Network Models
struct BreedList: Decodable, Equatable {
    let message: [String: [String]]
}

struct BreedImageList: Decodable {
    let message: [URL]
}

