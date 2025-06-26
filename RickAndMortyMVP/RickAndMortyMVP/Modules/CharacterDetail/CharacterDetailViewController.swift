//
//  CharacterDetailViewController.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 23.06.2025.
//

import Foundation
import UIKit

struct CharacterDetailViewModel {
    let name: String
    let imageUrl: String
    let status: String
    let species: String
    let gender: String
    let episodes: [String]
    let location: String
    
    init(char: RMCharacter) {
        self.name = char.name
        self.imageUrl = char.image
        self.status = char.status.displayName
        self.species = char.species
        self.gender = char.gender.displayName
        self.episodes = char.episode
        self.location = char.location.name
    }
}

import UIKit

final class CharacterDetailViewController: UIViewController {
    
    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let infoLabel = UILabel()
    private let episodesLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Dependencies
    var presenter: CharacterDetailPresenterInput!
    
    // MARK: - State
    private var isFavorite: Bool = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Character Details"
        view.backgroundColor = .systemBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 12
        contentView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 8
        avatarImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.numberOfLines = 0

        infoLabel.font = .systemFont(ofSize: 16)
        infoLabel.textColor = .secondaryLabel
        infoLabel.numberOfLines = 0

        episodesLabel.font = .systemFont(ofSize: 14)
        episodesLabel.numberOfLines = 0

        favoriteButton.setTitle("Add to Favorites", for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true

        [avatarImageView, nameLabel, infoLabel, episodesLabel, favoriteButton].forEach {
            contentView.addArrangedSubview($0)
        }

        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func favoriteTapped() {
        isFavorite.toggle()
        presenter.addToFavoriteTapped()
    }
}

// MARK: - Presenter Output
extension CharacterDetailViewController: CharacterDetailPresenterOutput {
    
    func showCharacterDetail(character: CharacterDetailViewModel, episodes: [String]) {
        nameLabel.text = character.name
        infoLabel.text = "Status: \(character.status)\nGender: \(character.gender)\nSpecies: \(character.species)"

        episodesLabel.text = "Episodes:\n" + episodes.joined(separator: "\n")

        if let url = URL(string: character.imageUrl) {
            // Используем обычный способ загрузки изображения (без Kingfisher)
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self?.avatarImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    func showFavoriteStatusChanged(isFavorite: Bool) {
        let title = isFavorite ? "Remove from Favorites" : "Add to Favorites"
        favoriteButton.setTitle(title, for: .normal)
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }
}
