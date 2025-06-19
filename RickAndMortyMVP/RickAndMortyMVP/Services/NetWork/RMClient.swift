//
//  ApiClient.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

protocol RMClient{
    func fetchCharacters(page: Int?, filters: [String: String]?) async throws -> RMCharacterResponse
    func fetchEpisodes(ids: [String]) async throws -> [RMEpisode]
}
