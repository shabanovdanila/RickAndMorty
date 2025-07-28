//
//  CharacterListViewController.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import UIKit

final class CharacterListViewController: UIViewController {
    
    private var characters: [CharacterViewModel] = []
    
    // MARK: - UI Elements
    private lazy var rmLabel: UILabel = {
        let label = UILabel()
        label.text = "Rick & Morty Characters"
        label.font = UIFont.customFont(weight: 700, size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterCellView.self, forCellReuseIdentifier: CharacterCellView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return control
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(showFilterOptions))
        return button
    }()
    
    // MARK: - Properties
    var presenter: CharacterListPresenterInput!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black
        tableView.backgroundColor = UIColor.black
        rmLabel.textColor = UIColor.white
        navigationItem.rightBarButtonItem = filterButton
        
        view.addSubview(rmLabel)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            rmLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 66),
            rmLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 57),
            
            tableView.topAnchor.constraint(equalTo: rmLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            //TODO
            loadingIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func refreshData() {
        presenter.applyFilters(filters: CharacterFilter())
        refreshControl.endRefreshing()
    }
    
    @objc private func showFilterOptions() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        let navVC = UINavigationController(rootViewController: filterVC)
        present(navVC, animated: true)
    }
}

// MARK: - Presenter Output
extension CharacterListViewController: CharacterListPresenterOutput {
    
    func showCharacters(characters: [CharacterViewModel]) {
        self.characters = characters
        self.tableView.reloadData()
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


// MARK: - TableView DataSource & Delegate
extension CharacterListViewController: UITableViewDataSource, UITableViewDelegate {
    // Количество секций = количеству ячеек
    func numberOfSections(in tableView: UITableView) -> Int {
        return characters.count
    }
    
    // В каждой секции только 1 ячейка
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterCellView.reuseIdentifier,
            for: indexPath
        ) as? CharacterCellView else {
            return UITableViewCell()
        }
        
        let character = characters[indexPath.section]
        cell.configure(with: character)
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        return cell
    }
    
    // Высота футера секции (создает отступ между ячейками)
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    // Прозрачный футер для секции
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectCharacter(at: indexPath.section)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            presenter.listScrolledToBottom()
        }
    }
}

// MARK: - Filter Delegate
extension CharacterListViewController: FilterDelegate {
    func didApplyFilters(_ filters: CharacterFilter) {
        presenter.applyFilters(filters: filters)
    }
    
    func didResetFilters() {
        presenter.resetFilters()
    }
}
