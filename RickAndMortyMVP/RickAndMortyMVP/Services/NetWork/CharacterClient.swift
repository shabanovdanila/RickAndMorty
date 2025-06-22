//
//  ApiClient.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

protocol CharacterClient {
    func fetchCharacters(page: Int?, filters: CharacterFilter?) async throws -> RMCharacterResponse
}
