//
//  ApiClient.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

protocol APIClient{
    func fetchCharacters(page: Int) async throws -> [Character]
    func fetchCharacter(by id: Int) async throws -> Character
}
