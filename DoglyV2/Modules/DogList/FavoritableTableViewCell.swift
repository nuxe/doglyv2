//
//  FavoritableTableViewCell.swift
//  DoglyV2
//
//  Created by Kush Agrawal on 1/31/25.
//

import UIKit

class FavoritableTableViewCell: UITableViewCell {
    static let reuseIdentifier = "FavoritableTableViewCell"
    
    // MARK: - UI Components
    private let subBreedLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        button.accessibilityLabel = "Favorite"
        return button
    }()
    
    // MARK: - Properties
    private var subBreed: SubBreed?
    var didUpdateFavorite: ((Bool) -> ())? = nil

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subBreed = nil
        subBreedLabel.text = nil
        favoriteButton.isSelected = false
        didUpdateFavorite = nil
    }
    
    // MARK: - Configuration
    func configure(subBreed: SubBreed) {
        self.subBreed = subBreed
        subBreedLabel.text = subBreed.name.capitalized
        favoriteButton.isSelected = subBreed.isFavorite
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        selectionStyle = .none
        let stackView = UIStackView(arrangedSubviews: [subBreedLabel, favoriteButton])
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    @objc private func didTapFavorite() {
        guard let subBreed = subBreed else { return }
        didUpdateFavorite?(!subBreed.isFavorite)
    }
}
