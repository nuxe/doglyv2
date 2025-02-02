//
//  FavoriteHeaderView.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/31/25.
//

import UIKit

class FavoriteHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "FavoriteHeaderView"
    
    // MARK: - Properties
    private var item: Favoritable?
    var didUpdateFavorite: ((Bool) -> Void)?
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        button.accessibilityLabel = "Favorite All"
        return button
    }()
    
    // MARK: - Initialization
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
        titleLabel.text = nil
        favoriteButton.isSelected = false
        didUpdateFavorite = nil
    }
    
    // MARK: - Configuration
    func configure(with item: Favoritable) {
        self.item = item
        titleLabel.text = item.name
        favoriteButton.isSelected = item.isFavorite
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        contentView.backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, favoriteButton])
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    @objc private func didTapFavorite() {
        guard let item = item else { return }
        didUpdateFavorite?(!item.isFavorite)
    }
}
