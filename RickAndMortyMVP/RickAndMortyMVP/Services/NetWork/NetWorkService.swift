//
//  NetWorkService.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(endpoint: String, queryItems: [URLQueryItem]?) async throws -> T
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
