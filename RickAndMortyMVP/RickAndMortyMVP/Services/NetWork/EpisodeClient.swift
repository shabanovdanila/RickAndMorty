//
//  EpisodeClient.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

protocol EpisodeClient {
    func fetchEpisodes(ids: [String]) async throws -> [RMEpisode]
}
