//
//  RMClient.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

final class CharacterClientDefault: CharacterClient {
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchCharacters(page: Int? = nil, filters: CharacterFilter? = nil) async throws -> RMCharacterResponse {
        var queryItems: [URLQueryItem] = []
        
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        
        if let filters {
            queryItems += filters.toQueryItems()
        }
        
        return try await networkService.request(
            endpoint: "character",
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
    }
}
