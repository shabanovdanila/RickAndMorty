//
//  CharacterDetailContracts.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 23.06.2025.
//

import Foundation

//Presenter -> View
protocol CharacterDetailPresenterOutput: AnyObject {
    func showCharacterDetail(character: CharacterDetailViewModel, episodes: [String])
    func showFavoriteStatusChanged(isFavorite: Bool)
    func showError(message: String)
    func showLoading()
    func hideLoading()
}

//View -> Presenter
protocol CharacterDetailPresenterInput: AnyObject {
    func viewDidLoad()
    func addToFavoriteTapped()
}

//Presenter -> Router
protocol CharacterDetailRouterInput: AnyObject {
    func backToMainScreen()
}
