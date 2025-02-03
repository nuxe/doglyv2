//
//  MockDogDetailViewModel.swift
//  DoglyV2Tests
//
//  Created by Kush Agrawal on 1/30/25.
//

import Foundation
import Testing
@testable import DoglyV2

class MockDogDetailViewModel: DogDetailViewModelProtocol {
    var breedImages: [URL] = []
    var errorMessage: String?
    
    var refetchCallCount = 0
    func refetch() {
        refetchCallCount += 1
    }
}
