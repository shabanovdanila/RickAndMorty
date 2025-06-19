//
//  EpisodeClientDefault.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

final class EpisodeClientDefault: EpisodeClient {
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchEpisodes(ids: [String]) async throws -> [RMEpisode] {
        func getNumberFromString(if stringId: String) -> String {
            stringId.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        }
        let ids = ids.map(getNumberFromString).joined(separator: ",")
        
        return try await networkService.request(
            endpoint: "episode/[\(ids)]",
            queryItems: nil
        )
    }
}
