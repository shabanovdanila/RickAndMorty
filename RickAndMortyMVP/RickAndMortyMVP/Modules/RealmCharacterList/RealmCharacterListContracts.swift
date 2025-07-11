//
//  RealmCharacterListContracts.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 09.07.2025.
//

import Foundation
// View -> Presenter
protocol RealmCharacterListPresenterInput: AnyObject {
    func viewDidLoad()
    func didSelectCharacter(at index: Int)
}

// Presenter -> View
protocol RealmCharacterListPresenterOutput: AnyObject {
    func showCharacters(characters: [CharacterViewModel])
    func showError(message: String)
    func showLoading()
    func hideLoading()
}

// Presenter -> Router
protocol RealmCharacterListRouterInput: AnyObject {
    func showCharacterDetails(character: RMCharacter)
}
