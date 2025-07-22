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
    func viewWillAppear()
    func didSelectCharacter(at index: Int)
    func listScrolledToBottom()
    func applyFilters(filters: CharacterFilter)
    func resetFilters()
}

// Presenter -> View
protocol CharacterListPresenterOutput: AnyObject {
    func showCharacters(characters: [CharacterViewModel])
    func showError(message: String)
    func showLoading()
    func hideLoading()
}

// Presenter -> Router
protocol CharacterListRouterInput: AnyObject {
    func showCharacterDetails(character: RMCharacter)
}
