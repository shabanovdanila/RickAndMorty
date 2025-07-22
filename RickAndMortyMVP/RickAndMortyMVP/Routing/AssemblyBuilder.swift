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
    func createCharacterListModule(router: CharacterListRouterInput) -> UIViewController
    func createCharacterDetailModule(character: RMCharacter, router: CharacterDetailRouterInput) -> UIViewController
    func createRealmListModule(router: RealmCharacterListRouterInput) -> UIViewController
}

final class AssemblyBuilderDefault: AssemblyBuilder {
    // MARK: - Main TabBar
    func createMainTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        // Настраиваем navigation controllers
        let charactersNavController = UINavigationController()
        charactersNavController.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(systemName: "person.2"),
            selectedImage: UIImage(systemName: "person.2.fill")
        )
        
        let favoritesNavController = UINavigationController()
        favoritesNavController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        // Создаем роутеры для каждой вкладки с правильными параметрами
        let charactersRouter = RouterDefault(navigationController: charactersNavController, assemblyBuilder: self)
        let favoritesRouter = RouterDefault(navigationController: favoritesNavController, assemblyBuilder: self)
        
        // Создаем модули
        let charactersModule = createCharacterListModule(router: charactersRouter)
        let favoritesModule = createRealmListModule(router: favoritesRouter)
        
        // Устанавливаем root view controllers
        charactersNavController.viewControllers = [charactersModule]
        favoritesNavController.viewControllers = [favoritesModule]
        
        // Добавляем вкладки в TabBar
        tabBarController.viewControllers = [charactersNavController, favoritesNavController]
        
        return tabBarController
    }

    
    
    //MARK: - Modules
    func createRealmListModule(router: RealmCharacterListRouterInput) -> UIViewController {
        let view = RealmCharacterListViewController()
        let realmClient = DependencyContainer.shared.createFavoriteStorageService()
        let presenter = RealmCharacterListPresenter(view: view, realmClient: realmClient, router: router)
        view.presenter = presenter
        return view
    }
    
    
    func createCharacterListModule(router: CharacterListRouterInput) -> UIViewController {
        let view = CharacterListViewController()
        let apiClient = DependencyContainer.shared.createCharacterСlient()
        let presenter = CharacterListPresenter(view: view, router: router, apiClient: apiClient)
        view.presenter = presenter
        return view
    }

    func createCharacterDetailModule(character: RMCharacter, router: CharacterDetailRouterInput) -> UIViewController {
        let view = CharacterDetailViewController()
        let apiClient = DependencyContainer.shared.createEpisodeClient()
        let favoritesService = DependencyContainer.shared.createFavoriteStorageService()
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
extension RouterDefault: RealmCharacterListRouterInput {
    func showCharacterDetailsRealm(character: RMCharacter) {
        self.showDetail(character: character)
    }
}
extension RouterDefault: CharacterDetailRouterInput {
    func backToMainScreen() {
        self.popToRoot()
    }
}
