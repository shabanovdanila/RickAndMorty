//
//  CharacterViewModel.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 22.07.2025.
//

struct CharacterViewModel {
    let name: String
    let status: String
    let species: String
    let imageUrl: String
    let gender: String
    
    init(char: RMCharacter) {
        self.name = char.name
        self.status = char.status.displayName
        self.species = char.species
        self.imageUrl = char.image
        self.gender = char.gender.displayName
    }
}
