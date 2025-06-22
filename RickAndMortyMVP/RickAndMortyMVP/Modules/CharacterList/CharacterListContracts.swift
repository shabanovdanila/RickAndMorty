//
//  CharacterListContracts.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//
import Foundation
// View -> Presenter
protocol CharacterListPresenterInput: AnyObject {
    func viewDidLoad()
    func didSelectCharacter(character: RMCharacter)
    func loadNextPage()
    func applyFilters(filters: CharacterFilter)
    func resetFilters()
}

// Presenter -> View
protocol CharacterListPresenterOutput: AnyObject {
    func showCharacters(characters: [RMCharacter])
    func showError(message: String)
    func showLoading()
    func hideLoading()
}

// Presenter -> Router
protocol CharacterListRouterInput {
    func showCharacterDetails(character: RMCharacter)
}
