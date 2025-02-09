//
//  DogListViewController.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import UIKit

class DogListViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: DogListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.register(FavoritableTableViewCell.self, forCellReuseIdentifier: FavoritableTableViewCell.reuseIdentifier)
        view.register(FavoriteHeaderView.self, forHeaderFooterViewReuseIdentifier: FavoriteHeaderView.reuseIdentifier)
        view.refreshControl = refreshControl
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.backgroundColor = .gray
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    // MARK: - Lifecycle
    init(_ viewModel: DogListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        bindViewModel()
    }

    // MARK: - Setup
    private func setupSubviews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        Task {
            await viewModel.fetchList()
        }
        
        viewModel.$breeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.handleDataUpdate()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleDataUpdate()
                if let error { self?.showError(error) }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Helper Methods
    private func handleDataUpdate() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    @objc
    private func refresh() {
        Task {
            await viewModel.fetchList()
        }
    }
}

// MARK: - UITableViewDataSource
extension DogListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.breeds.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.breeds[section].subBreeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritableTableViewCell.reuseIdentifier, for: indexPath) as? FavoritableTableViewCell else {
            return FavoritableTableViewCell()
        }
        
        let breed = viewModel.breeds[indexPath.section]
        let subBreed = breed.subBreeds[indexPath.row]
        
        cell.configure(with: subBreed)
        cell.didUpdateFavorite = { [weak self] isFavorite in
            self?.viewModel.updateFavoriteSubBreed(breed.name, subBreed.name, isFavorite)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DogListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FavoriteHeaderView.reuseIdentifier) as? FavoriteHeaderView else {
            return FavoriteHeaderView()
        }
        
        let breedData = viewModel.breeds[section]
        header.configure(with: breedData)
        header.didUpdateFavorite = { [weak self] isFavorite in
            self?.viewModel.updateFavoriteBreed(breedData.name, isFavorite)
        }
        return header
    }
}
