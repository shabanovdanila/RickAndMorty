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
        //3 root controller =
        self.window?.rootViewController = ViewController()
        //4 make visible
        self.window?.makeKeyAndVisible()
    }
}
