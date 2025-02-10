//
//  MyApp.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 2/9/25.
//

import SwiftUI

@main
struct MyApp: App {

    // Create view models
    @StateObject private var dogListViewModel: DogListViewModel
    @StateObject private var dogDetailViewModel: DogDetailViewModel
    
    init() {
        // Initialize derived dependencies
        let networkClient = NetworkClient()
        let favoritesStorage = FavoritesStorage()
        let breedStream = BreedsStream(favoritesStorage: favoritesStorage)
        let breedService = BreedService(networkClient: networkClient)
        
        // Initialize view models
        _dogListViewModel = StateObject(wrappedValue: DogListViewModel(
            breedService: breedService,
            breedsStream: breedStream
        ))
        
        _dogDetailViewModel = StateObject(wrappedValue: DogDetailViewModel(
            breedService: breedService,
            breedsStream: breedStream
        ))
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(dogListViewModel)
                .environmentObject(dogDetailViewModel)
        }
    }
}
