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
        characters = realmClient.getAllCharacters()
    }
}
