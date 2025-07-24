//
//  MainTabBarController.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 24.07.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
    }

    // MARK: - Customization
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.stackedLayoutAppearance.selected.iconColor = .systemGreen
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
