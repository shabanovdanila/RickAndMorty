//
//  RealmCharacterListPresenter.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 09.07.2025.
//

import Foundation

final class RealmCharacterListPresenter {
    //MARK: - MVP Properties
    weak var view: RealmCharacterListPresenterOutput?
    private let realmClient: FavoriteStorageService
    private let router: RealmCharacterListRouterInput?
    
    //MARK: - Properties
    private var characters: [RMCharacter] = []
    private var isLoading: Bool = false
    
    init(view: RealmCharacterListPresenterOutput, realmClient: FavoriteStorageService, router: RealmCharacterListRouterInput) {
        self.view = view
        self.realmClient = realmClient
        self.router = router
    }
    
    private func fetchCharactersFromRealm() {
        guard !isLoading else { return }
        isLoading = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.view?.showLoading()
            
            let characters = self.realmClient.getAllCharacters()
            if characters.isEmpty {
                self.view?.showEmptyList()
            } else {
                self.view?.showCharacters(characters: characters.map(CharacterViewModel.init))
            }
        
            self.isLoading = false
            self.view?.hideLoading()
        }
    }
}
extension RealmCharacterListPresenter: RealmCharacterListPresenterInput {
    func viewDidLoad() {
        fetchCharactersFromRealm()
    }
    func viewWillAppear() {
        fetchCharactersFromRealm()
    }
    func didSelectCharacter(at index: Int) {
        guard let char = characters[safe: index] else { return }
        router?.showCharacterDetailsRealm(character: char)
    }
}
