//
//  RealmCharacterListViewController.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 09.07.2025.
//

import Foundation
import UIKit

final class RealmCharacterListViewController: UIViewController {
    
    //MARK: - UI Elements
    private lazy var rmLabel: UILabel = {
        let label = UILabel()
        label.text = "Realm Characters"
        label.font = UIFont.customFont(weight: 700, size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptyStateLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "No favorite characters yet"
            label.textAlignment = .center
            label.textColor = .gray
            label.font = .systemFont(ofSize: 18)
            label.isHidden = true
            return label
        }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterCellView.self, forCellReuseIdentifier: CharacterCellView.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Properties
    var presenter: RealmCharacterListPresenterInput!
    private var characters: [CharacterViewModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(rmLabel)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyStateLabel)
        NSLayoutConstraint.activate([
            rmLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            rmLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            
            tableView.topAnchor.constraint(equalTo: rmLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension RealmCharacterListViewController: RealmCharacterListPresenterOutput {
    func showCharacters(characters: [CharacterViewModel]) {
        self.characters = characters
        tableView.isHidden = false
        emptyStateLabel.isHidden = true
        self.tableView.reloadData()
    }
    
    func showEmptyList() {
        characters = []
        tableView.isHidden = true
        emptyStateLabel.isHidden = false
    }
    
    func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func showLoading() {
        self.loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        self.loadingIndicator.stopAnimating()
    }
}

extension RealmCharacterListViewController: UITableViewDataSource, UITableViewDelegate {
    //Количество строк
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    //Создание и настройка ячейки таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterCellView.reuseIdentifier,
            for: indexPath
        ) as? CharacterCellView else {
            return UITableViewCell()
        }
        
        let character = characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
    
    //Триггерится при нажатии на ячейку таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectCharacter(at: indexPath.row)
    }
}

