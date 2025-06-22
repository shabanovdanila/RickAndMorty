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
    //func createCharacterDetailModule(character: RMCharacter, router: CharacterListRouterInput) -> UIViewController
}

final class AssemblyBuilderDefault: AssemblyBuilder {
    func createCharacterListModule(router: CharacterListRouterInput) -> UIViewController {
        let view = CharacterListViewController()
        let apiClient = DependencyContainer.shared.createCharacterСlient()
        let presenter = CharacterListPresenter(view: view as CharacterListPresenterOutput, router: router, apiClient: apiClient)
        view.presenter = presenter
        return view
    }

//    func createCharacterDetailModule(character: RMCharacter, router: CharacterListRouterInput) -> UIViewController {
//        let view = CharacterDetailViewController()
//        let presenter = CharacterDetailPresenter(view: view, character: character)
//        view.presenter = presenter
//        return view
//    }
}

extension RouterDefault: CharacterListRouterInput {
    func showCharacterDetails(character: RMCharacter) {
        //self.showDetail(character: character)
    }
}
