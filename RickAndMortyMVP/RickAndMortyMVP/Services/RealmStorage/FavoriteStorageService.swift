//
//  FavoriteStorageService.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 26.06.2025.
//

import Foundation
import RealmSwift

protocol FavoriteStorageService {
    func add(_ character: RMCharacter)
    func remove(_ character: RMCharacter)
    func getAllCharacters() -> [RMCharacter]
    func getCharacterById(id: Int) -> RMCharacter?
    func isFavorite(_ character: RMCharacter) -> Bool
}

final class FavoriteStorageServiceDefault: FavoriteStorageService {
    
    private let realm = try! Realm()
    
    func add(_ character: RMCharacter) {
        let object = RealmCharacter(from: character)
        try? realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func remove(_ character: RMCharacter) {
        guard let object = realm.object(ofType: RealmCharacter.self, forPrimaryKey: character.id) else { return }
        try? realm.write {
            realm.delete(object)
        }
    }
    
    func getAllCharacters() -> [RMCharacter] {
        let characters = realm.objects(RealmCharacter.self)
        return Array(characters).map{ RMCharacter(from: $0)}
    }
    
    func getCharacterById(id: Int) -> RMCharacter? {
        guard let realmCharacter = realm.object(ofType: RealmCharacter.self, forPrimaryKey: id) else {
            return nil
        }
        return RMCharacter(from: realmCharacter)
    }
    
    func isFavorite(_ character: RMCharacter) -> Bool {
        realm.object(ofType: RealmCharacter.self, forPrimaryKey: character.id) != nil
    }
}
