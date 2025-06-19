//
//  RMClient.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

final class RMClientDefault: RMClient {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchCharacters(page: Int? = nil, filters: [String: String]? = nil) async throws -> RMCharacterResponse {
        var queryItems: [URLQueryItem] = []
        
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        
        if let filters {
            queryItems += filters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return try await networkService.request(
            endpoint: "character",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
    }
    
    func fetchEpisodes(ids: [String]) async throws -> [RMEpisode] {
        func getNumberFromString(if stringId: String) -> String {
            stringId.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        }
        let ids = ids.map(getNumberFromString).joined(separator: ",")
        
        return try await networkService.request(endpoint: "episode/[\(ids)]", queryItems: nil)
    }
}

