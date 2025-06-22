//
//  Router.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 22.06.2025.
//

import Foundation
import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilder? { get set }
}

protocol Router: RouterMain {
    func initialViewController()
    func showDetail(character: RMCharacter)
    func popToRoot()
}


final class RouterDefault: Router {
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilder?
    
    init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilder?) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController {
            guard let mainVC = assemblyBuilder?.createCharacterListModule(router: self) else { return }
            navigationController.viewControllers = [mainVC]
        }
    }
    
    func showDetail(character: RMCharacter) {
        if let navigationController {
            guard let detailVC = assemblyBuilder?.createCharacterDetailModule(character: character, router: self) else { return }
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
