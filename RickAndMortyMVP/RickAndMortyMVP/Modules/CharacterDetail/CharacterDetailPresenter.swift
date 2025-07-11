//
//  CharacterDetailPresenter.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 23.06.2025.
//

import Foundation

final class CharacterDetailPresenter {
    //MARK: - MVP
    weak var view: CharacterDetailPresenterOutput?
    private let router: CharacterDetailRouterInput?
    private let apiClient: EpisodeClient
    
    //MARK: - Properties
    private var character: RMCharacter
    private var episodes: [String] = []
    private var isLoading: Bool = false
    private let favoritesService: FavoriteStorageService
    private var isFavorite: Bool = false
    
    init(view: CharacterDetailPresenterOutput,
         router: CharacterDetailRouterInput,
         apiClient: EpisodeClient,
         character: RMCharacter,
         favoritesService: FavoriteStorageService) {
        self.view = view
        self.router = router
        self.apiClient = apiClient
        self.character = character
        self.favoritesService = favoritesService
    }
    
    
    private func fetchEpisodes() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            await MainActor.run{
                view?.showLoading()
            }
            
            do {
                episodes = try await apiClient.fetchEpisodes(ids: character.episode).map{$0.name}
                
                await MainActor.run {
                    view?.showCharacterDetail(character: CharacterDetailViewModel(char: character), episodes: episodes)
                }
                
            } catch {
                await MainActor.run {
                    view?.showError(message: error.localizedDescription)
                }
            }
            
            await MainActor.run {
                isLoading = false
                view?.hideLoading()
            }
        }
    }
    
    private func updateFavoriteStatus() {
        do {
            if isFavorite {
                try favoritesService.remove(character)
            } else {
                try favoritesService.add(character)
            }
            isFavorite.toggle()
            view?.showFavoriteStatusChanged(isFavorite: isFavorite)
        } catch {
            view?.showError(message: "Failed to update favorites: \(error.localizedDescription)")
        }
    }
}

extension CharacterDetailPresenter: CharacterDetailPresenterInput {
    func viewDidLoad() {
        isFavorite = favoritesService.isFavorite(character)
        view?.showFavoriteStatusChanged(isFavorite: isFavorite)
        fetchEpisodes()
    }
    
    func addToFavoriteTapped() {
            updateFavoriteStatus()
        }
}
