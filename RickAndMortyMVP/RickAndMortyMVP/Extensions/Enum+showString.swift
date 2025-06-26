//
//  Enum+String.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 25.06.2025.
//
extension Status {
    var displayName: String {
        switch self {
        case .Alive: return "Alive"
        case .Dead: return "Dead"
        case .Unknown: return "Unknown"
        }
    }
}

extension Gender {
    var displayName: String {
        switch self {
        case .Female: return "Female"
        case .Male: return "Male"
        case .Genderless: return "Genderless"
        case .Unknown: return "Unknown"
        }
    }
}
