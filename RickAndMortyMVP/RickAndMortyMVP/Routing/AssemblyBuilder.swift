//
//  AssemblyBuilder.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 22.06.2025.
//

import Foundation
import UIKit

protocol AssemblyBuilder {
    func createCharacterListModule(router: CharacterListRouterInput) -> UIViewController
    func createCharacterDetailModule(character: RMCharacter, router: CharacterDetailRouterInput) -> UIViewController
}

final class AssemblyBuilderDefault: AssemblyBuilder {
    
    func createCharacterListModule(router: CharacterListRouterInput) -> UIViewController {
        let view = CharacterListViewController()
        let apiClient = DependencyContainer.shared.createCharacterСlient()
        let presenter = CharacterListPresenter(view: view as CharacterListPresenterOutput, router: router, apiClient: apiClient)
        view.presenter = presenter
        return view
    }

    func createCharacterDetailModule(character: RMCharacter, router: CharacterDetailRouterInput) -> UIViewController {
        let view = CharacterDetailViewController()
        let apiClient = DependencyContainer.shared.createEpisodeClient()
        let favoritesService = FavoriteStorageServiceDefault()
        let presenter = CharacterDetailPresenter(
            view: view,
            router: router,
            apiClient: apiClient,
            character: character,
            favoritesService: favoritesService
        )
        view.presenter = presenter
        return view
    }
}

extension RouterDefault: CharacterListRouterInput {
    func showCharacterDetails(character: RMCharacter) {
        self.showDetail(character: character)
    }
}

extension RouterDefault: CharacterDetailRouterInput {
    func backToMainScreen() {
        self.popToRoot()
    }
}
