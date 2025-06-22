//
//  CharacterFilter.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 22.06.2025.
//

import Foundation

struct CharacterFilter {
    var name: String?
    var status: String? // alive, dead, unknown
    var species: String?
    var type: String?
    var gender: String? // female, male, unknown, genderless
    
    var isEmpty: Bool {
        return name == nil && status == nil && species == nil && type == nil && gender == nil
    }
    
    func toQueryItems() -> [URLQueryItem] {
        var items = [URLQueryItem]()
        if let name = name { items.append(URLQueryItem(name: "name", value: name)) }
        if let status = status { items.append(URLQueryItem(name: "status", value: status)) }
        if let species = species { items.append(URLQueryItem(name: "species", value: species)) }
        if let type = type { items.append(URLQueryItem(name: "type", value: type)) }
        if let gender = gender { items.append(URLQueryItem(name: "gender", value: gender)) }
        return items
    }
}
