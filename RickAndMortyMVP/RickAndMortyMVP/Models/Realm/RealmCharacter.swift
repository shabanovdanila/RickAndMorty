//
//  RealmRMCharacter.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 26.06.2025.
//

import Foundation
import RealmSwift

final class RealmCharacter: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var statusRaw: String
    @Persisted var species: String
    @Persisted var genderRaw: String
    @Persisted var locationName: String
    @Persisted var image: String
    @Persisted var episodes: List<String>
    
    convenience init(from character: RMCharacter) {
        self.init()
        self.id = character.id
        self.name = character.name
        self.statusRaw = character.status.rawValue
        self.species = character.species
        self.genderRaw = character.gender.rawValue
        self.locationName = character.location.name
        self.image = character.image
        self.episodes.append(objectsIn: character.episode)
    }
}
