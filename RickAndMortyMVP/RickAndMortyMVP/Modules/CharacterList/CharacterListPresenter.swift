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
    private let router: CharacterListRouterInput?
    private let apiClient: CharacterClient
 
    //MARK: - properties
    private var characters: [RMCharacter] = []
    private var currentFilters: CharacterFilter?
    
    //MARK: - pagination
    private var nextPage: Int = 0
    private var hasNextPage = true
    private var isLoading = false
    
    init(view: CharacterListPresenterOutput,
         router: CharacterListRouterInput,
         apiClient: CharacterClient) {
        self.view = view
        self.router = router
        self.apiClient = apiClient
    }
    
    private func fetchCharacters(page: Int, filters: CharacterFilter? = nil, shouldReset: Bool = false) {
        guard hasNextPage, !isLoading else { return }
        isLoading = true
        Task {
            await MainActor.run {
                view?.showLoading()
            }
            
            do {
                let newCharacters = try await apiClient.fetchCharacters(page: page, filters: filters)
                
                if shouldReset {
                    characters = newCharacters.results
                } else {
                    characters.append(contentsOf: newCharacters.results)
                }
                
                hasNextPage = newCharacters.info.next != nil
                nextPage = page + 1
                
                await MainActor.run {
                    view?.showCharacters(characters: characters.map(CharacterViewModel.init))
                }
            } catch {
                await MainActor.run {
                    print(error)
                    view?.showError(message: error.localizedDescription)
                }
            }
            
            await MainActor.run {
                isLoading = false
                view?.hideLoading()
            }
        }
    }
}

extension CharacterListPresenter: CharacterListPresenterInput {
    
    func viewDidLoad() {
        nextPage = 1
        fetchCharacters(page: nextPage, shouldReset: true)
    }
    
    func didSelectCharacter(at index: Int) {
        guard let char = characters[safe: index] else { return }
        router?.showCharacterDetails(character: char)
    }
    
    func listScrolledToBottom() {
        fetchCharacters(page: nextPage, filters: currentFilters)
    }
    
    func applyFilters(filters: CharacterFilter) {
        currentFilters = filters
        nextPage = 1
        fetchCharacters(page: nextPage, filters: filters, shouldReset: true)
    }
    
    func resetFilters() {
        currentFilters = nil
        nextPage = 1
        fetchCharacters(page: nextPage, filters: nil, shouldReset: true)
    }
}
