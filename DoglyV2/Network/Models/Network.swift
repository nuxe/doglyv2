//
//  Breed.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Foundation

// Network models
struct BreedList: Decodable {
    let message: [String: [String]]
}

struct BreedImageList: Decodable {
    let message: [URL]
}

