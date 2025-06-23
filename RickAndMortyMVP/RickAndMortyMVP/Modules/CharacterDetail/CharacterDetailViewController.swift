//
//  CharacterDetailViewController.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 23.06.2025.
//

import Foundation

struct CharacterDetailViewModel {
    let name: String
    let imageUrl: String
    let status: String
    let species: String
    let gender: String
    let episodes: [String]
    let location: String
    
    init(char: RMCharacter) {
        self.name = char.name
        self.imageUrl = char.image
        self.status = char.status.displayName
        self.species = char.species
        self.gender = char.gender.displayName
        self.episodes = char.episode
        self.location = char.location.name
    }
}
