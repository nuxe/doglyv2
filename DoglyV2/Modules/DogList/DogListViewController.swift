//
//  DogListViewController.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/30/25.
//

import Combine
import UIKit

class DogListViewController: UIViewController {
        
    private let viewModel: DogListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.register(FavoritableTableViewCell.self, forCellReuseIdentifier: FavoritableTableViewCell.reuseIdentifier)
        view.register(SectionHeaderFavoriteView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderFavoriteView.reuseIdentifier)
        view.refreshControl = refreshControl
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.backgroundColor = .gray
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
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

    private func setupSubviews() {
        view.addSubview(tableView)
        
        // Apply constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.fetchList()
        
        viewModel.$breeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                if let error {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    @objc
    private func refresh() {
        viewModel.fetchList()
    }
    
}

extension DogListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.breeds.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breeds[section].subBreeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritableTableViewCell.reuseIdentifier, for: indexPath) as? FavoritableTableViewCell else {
            return FavoritableTableViewCell()
        }
        let breed = viewModel.breeds[indexPath.section]
        let row = indexPath.row
        let subBreed = breed.subBreeds[row]
        cell.configure(subBreed: subBreed)
        
        cell.didUpdateFavorite = { [weak self] isFavorite in
            self?.viewModel.updateFavoriteSubBreed(breed.name, subBreed.name, isFavorite)
        }

        return cell
    }
}

extension DogListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderFavoriteView.reuseIdentifier) as? SectionHeaderFavoriteView else {
            return SectionHeaderFavoriteView()
        }
        let breedData = viewModel.breeds[section]
        header.configure(breedData: breedData)
        header.didUpdateFavorite = { [weak self] isFavorite in
            self?.viewModel.updateFavoriteBreed(breedData.name, isFavorite)
        }
        return header
    }
}
