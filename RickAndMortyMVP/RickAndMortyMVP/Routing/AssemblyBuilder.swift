//
//  AssemblyBuilder.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 22.06.2025.
//

import Foundation
import UIKit

protocol AssemblyBuilder {
    func createMainTabBarController() -> UITabBarController
    func createCharacterListModule(router: CharacterListRouterInput) -> CharacterListViewController
    func createCharacterDetailModule(character: RMCharacter, router: CharacterDetailRouterInput) -> CharacterDetailViewController
    func createRealmListModule(router: RealmCharacterListRouterInput) -> RealmCharacterListViewController
}

final class AssemblyBuilderDefault: AssemblyBuilder {
    
    //MARK: - Properties
    private let dependencyContainer: DependencyContainer
    
    //MARK: - Init
    init(dependencyContainer: DependencyContainer = DependencyContainer.shared) {
        self.dependencyContainer = dependencyContainer
    }
    
    // MARK: - Main TabBar
    func createMainTabBarController() -> UITabBarController {
        let tabBarController = MainTabBarController()
        
        let charactersNavController = UINavigationController()
        charactersNavController.tabBarItem = makeTabBarItem(for: .characters)
        
        let favoritesNavController = UINavigationController()
        favoritesNavController.tabBarItem = makeTabBarItem(for: .favorites)
        
        let charactersRouter = RouterDefault(
            navigationController: charactersNavController,
            assemblyBuilder: self
        )
        let favoritesRouter = RouterDefault(
            navigationController: favoritesNavController,
            assemblyBuilder: self
        )
        
        charactersNavController.viewControllers = [
            createCharacterListModule(router: charactersRouter)
        ]
        favoritesNavController.viewControllers = [
            createRealmListModule(router: favoritesRouter)
        ]
        
        tabBarController.viewControllers = [charactersNavController, favoritesNavController]
        return tabBarController
    }
    
    private func makeTabBarItem(for type: TabType) -> UITabBarItem {
        switch type {
        case .characters:
            return UITabBarItem(
                title: TabBarConstants.Titles.characters,
                image: UIImage(systemName: TabBarConstants.Images.characters),
                selectedImage: UIImage(systemName: TabBarConstants.Images.charactersFilled)
            )
        case .favorites:
            return UITabBarItem(
                title: TabBarConstants.Titles.favorites,
                image: UIImage(systemName: TabBarConstants.Images.favorites),
                selectedImage: UIImage(systemName: TabBarConstants.Images.favoritesFilled)
            )
        }
    }
    
    //MARK: - Enums
    private enum TabType {
        case characters
        case favorites
    }
    
    //MARK: - Modules
    func createRealmListModule(router: RealmCharacterListRouterInput) -> RealmCharacterListViewController {
        let view = RealmCharacterListViewController()
        let realmClient = dependencyContainer.createFavoriteStorageService()
        let presenter = RealmCharacterListPresenter(view: view, realmClient: realmClient, router: router)
        view.presenter = presenter
        return view
    }
    
    
    func createCharacterListModule(router: CharacterListRouterInput) -> CharacterListViewController {
        let view = CharacterListViewController()
        let apiClient = dependencyContainer.createCharacterСlient()
        let presenter = CharacterListPresenter(view: view, router: router, apiClient: apiClient)
        view.presenter = presenter
        return view
    }

    func createCharacterDetailModule(character: RMCharacter, router: CharacterDetailRouterInput) -> CharacterDetailViewController {
        let view = CharacterDetailViewController()
        let apiClient = dependencyContainer.createEpisodeClient()
        let favoritesService = dependencyContainer.createFavoriteStorageService()
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

//MARK: - Extensions
extension RouterDefault: CharacterListRouterInput, RealmCharacterListRouterInput, CharacterDetailRouterInput {
    func showCharacterDetails(character: RMCharacter) {
        self.showDetail(character: character)
    }
    func showCharacterDetailsRealm(character: RMCharacter) {
        self.showDetail(character: character)
    }
    func backToMainScreen() {
        self.popToRoot()
    }
}
