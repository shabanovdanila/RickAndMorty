//
//  DependencyContainer.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

final class DependencyContainer {
    
    static let shared = DependencyContainer()

    private let sharedNetWorkService: NetworkService
    
    private init() {
        let baseURL = "https://rickandmortyapi.com/api"
        self.sharedNetWorkService = NetworkServiceDefault(baseURL: baseURL)
    }
    
    // MARK: - Clients
    func createCharacterСlient() -> CharacterClientDefault {
        CharacterClientDefault(networkService: sharedNetWorkService)
    }
    
    func createEpisodeClient() -> EpisodeClientDefault {
        EpisodeClientDefault(networkService: sharedNetWorkService)
    }
    
    func createFavoriteStorageService() -> FavoriteStorageService {
        do {
            return try FavoriteStorageServiceDefault()
        } catch {
            fatalError("Failed to initialize FavoriteStorageService: \(error)")
        }
    }
}
