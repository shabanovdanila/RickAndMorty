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

enum Status: Codable {
    case alive
    case dead
    case unknown
}

enum Gender: Codable {
    case female
    case male
    case unknown
    case genderless
}
