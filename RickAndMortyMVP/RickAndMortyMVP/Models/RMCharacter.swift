//
//  Character.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 19.06.2025.
//

import Foundation

struct RMCharacter: Codable, Identifiable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let gender: Gender
    let location: RMLocation
    let image: String
    let episode: [String]
    let url: String
}

enum Status: String, Codable {
    case Alive
    case Dead
    case Unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = Status(rawValue: raw) ?? .Unknown
    }
}

enum Gender: String, Codable {
    case Female
    case Male
    case Unknown
    case Genderless
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = Gender(rawValue: raw) ?? .Unknown
    }
}
