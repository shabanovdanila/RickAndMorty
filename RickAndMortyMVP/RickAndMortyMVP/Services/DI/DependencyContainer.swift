//
//  DependencyContainer.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

final class DependencyContainer {
    
    static let shared = DependencyContainer()
    
    private let baseURL: String
    private let sharedNetWorkService: NetworkService
    
    private init() {
        self.baseURL = "https://rickandmortyapi.com/api"
        self.sharedNetWorkService = NetworkServiceDefault(baseURL: baseURL)
    }
    
    // MARK: - Clients
    func createCharacterlient() -> CharacterClientDefault {
        CharacterClientDefault(networkService: sharedNetWorkService)
    }
    
    func createEpisodeClient() -> EpisodeClientDefault {
        EpisodeClientDefault(networkService: sharedNetWorkService)
    }
}
