//
//  SceneDelegate.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        //2 init window
        self.window = UIWindow(windowScene: scene)
        
        let assemblyBuilder = AssemblyBuilderDefault()
        let tabBarController = assemblyBuilder.createMainTabBarController()
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        
//        // Сборка модуля
//        let navigationController = UINavigationController()
//        let assemblyBuilder = AssemblyBuilderDefault()
//        let router = RouterDefault(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
//        router.setupRootViewController()
//        let characterListVC = assemblyBuilder.createCharacterListModule(router: router)
//        
//        // Установка корневого контроллера
//        navigationController.viewControllers = [characterListVC]
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
