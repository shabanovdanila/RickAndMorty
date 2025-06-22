//
//  CharacterListPresenter.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

final class CharacterListPresenter {

    //MARK: - MVP
    weak var view: CharacterListPresenterOutput?
    private let router: CharacterListRouterInput
    private let apiClient: CharacterClient
 
    //MARK: - properties
    private var characters: [RMCharacter] = []
    private var currentFilters: CharacterFilter?
    
    //MARK: - pagination
    private var currentPage = 1
    private var hasNextPage = true
    private var isLoading = false
    
    init(view: CharacterListPresenterOutput,
         router: CharacterListRouterInput,
         apiClient: CharacterClient) {
        self.view = view
        self.router = router
        self.apiClient = apiClient
    }
    
    private func fetchCharacters(page: Int, filters: CharacterFilter? = nil) {
        guard hasNextPage, !isLoading else {return}
        
        isLoading = true
        view?.showLoading()
        Task {
            do {
                let newCharacters = try await apiClient.fetchCharacters(page: page, filters: filters)
                
                if page == 1 {
                    characters = newCharacters.results
                } else {
                    characters.append(contentsOf: newCharacters.results)
                }
                
                view?.showCharacters(characters: characters)
                
                hasNextPage = newCharacters.info.next != nil
                currentPage = page + 1
            } catch {
                view?.showError(message: error.localizedDescription)
            }
            isLoading = false
            view?.hideLoading()
        }
    }
}

extension CharacterListPresenter: CharacterListPresenterInput {
    
    func viewDidLoad() {
        currentPage = 1
        fetchCharacters(page: currentPage)
    }
    
    func didSelectCharacter(character: RMCharacter) {
        router.showCharacterDetails(character: character)
    }
    
    func loadNextPage() {
        fetchCharacters(page: currentPage, filters: currentFilters)
    }
    
    func applyFilters(filters: CharacterFilter) {
        currentFilters = filters
        currentPage = 1
        fetchCharacters(page: currentPage, filters: filters)
    }
    
    func resetFilters() {
        currentFilters = nil
        currentPage = 1
        fetchCharacters(page: currentPage)
    }
}
