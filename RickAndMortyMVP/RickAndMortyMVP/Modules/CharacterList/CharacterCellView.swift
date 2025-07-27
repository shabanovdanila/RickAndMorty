//
//  CharacterCellView.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 22.06.2025.
//
import UIKit

final class CharacterCellView: UITableViewCell {
    static let reuseIdentifier = "CharacterCell"

    // MARK: - UI Elements
    private let cardBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grayCardRM
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(weight: 500, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusSpeciesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(weight: 600, size: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(weight: 400, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with character: CharacterViewModel) {
        nameLabel.text = character.name
        nameLabel.textColor = UIColor.white
        
        //status + species label
        let statusColor: UIColor = character.status.lowercased() == "alive" ? .systemGreen : .white

        let statusText = NSAttributedString(
            string: character.status,
            attributes: [.foregroundColor: statusColor]
        )

        let speciesText = NSAttributedString(
            string: " • \(character.species)",
            attributes: [.foregroundColor: UIColor.white]
        )

        let combined = NSMutableAttributedString()
        combined.append(statusText)
        combined.append(speciesText)
        statusSpeciesLabel.attributedText = combined

        genderLabel.text = character.gender
        genderLabel.textColor = UIColor.white
        avatarImageView.image = nil
        if let url = URL(string: character.imageUrl) {
            loadImage(from: url)
        }
    }

    //TODO: - Вынести отсюда
    // MARK: - Image Loading
    private func loadImage(from url: URL) {
        let cache = URLCache.shared

        let request = URLRequest(url: url)

        if let data = cache.cachedResponse(for: request)?.data,
           let image = UIImage(data: data) {
            avatarImageView.image = image
            return
        }

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard
                let self,
                let data,
                let response,
                let image = UIImage(data: data)
            else {
                return
            }

            let cachedData = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedData, for: request)

            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }.resume()
    }

    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(cardBackgroundView)
        cardBackgroundView.addSubview(avatarImageView)
        cardBackgroundView.addSubview(nameLabel)
        cardBackgroundView.addSubview(statusSpeciesLabel)
        cardBackgroundView.addSubview(genderLabel)
        
        NSLayoutConstraint.activate([
            cardBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            cardBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            cardBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            cardBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            avatarImageView.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: cardBackgroundView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 84),
            avatarImageView.heightAnchor.constraint(equalToConstant: 64),


            nameLabel.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),

            statusSpeciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            statusSpeciesLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusSpeciesLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardBackgroundView.trailingAnchor, constant: -16),

            genderLabel.topAnchor.constraint(equalTo: statusSpeciesLabel.bottomAnchor, constant: 6),
            genderLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            genderLabel.trailingAnchor.constraint(equalTo: statusSpeciesLabel.trailingAnchor),
            genderLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardBackgroundView.bottomAnchor, constant: -18)
        ])
    }
}
