//
//  MainTabBarController.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        // Dependecies
        let favoritesStorage: FavoritesStorageProtocol = FavoritesStorage()
        let breedStream: BreedsStreamProtocol = BreedsStream(favoritesStorage: favoritesStorage)
        let networkClient: NetworkClientProtocol = NetworkClient()
        let breedService: BreedServiceProtocol = BreedService(networkClient: networkClient)

        // List
        let dogListViewModel = DogListViewModel(breedService: breedService, breedsStream: breedStream)
        let list = DogListViewController(dogListViewModel)
        list.title = "Breeds"
        list.tabBarItem = UITabBarItem(title: "Breeds", image: UIImage(systemName: "list.bullet"), selectedImage: UIImage(systemName: "list.bullet.circle.fill"))

        // Detail
        let dogDetailViewModel = DogDetailViewModel(breedService: breedService, breedsStream: breedStream)
        let detail = DogDetailViewController(dogDetailViewModel)
        detail.title = "Details"
        detail.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))

        let listNav = UINavigationController(rootViewController: list)
        let detailNav = UINavigationController(rootViewController: detail)

        // Assign to tab bar controller
        viewControllers = [listNav, detailNav]

        // Customize tab bar appearance (optional)
        tabBar.tintColor = .systemBlue  // Active tab color
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .white
    }
}
