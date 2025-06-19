//
//  NetWorkServiceDefault.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

final class NetworkServiceDefault: NetworkService {
    private let baseURL: String
    private let urlSession: URLSession
    
    init(baseURL: String,
         urlSession: URLSession = .shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(endpoint: String, queryItems: [URLQueryItem]? = nil) async throws -> T {
        guard let url = buildURL(endpoint: endpoint, queryItems: queryItems) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    private func buildURL(endpoint: String, queryItems: [URLQueryItem]?) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path = "/api/\(endpoint)"
        components?.queryItems = queryItems?.isEmpty == true ? nil : queryItems
        return components?.url
    }
}
