//
//  FavoriteStorageService.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 26.06.2025.
//

import Foundation
import RealmSwift

protocol FavoriteStorageService {
    func add(_ character: RMCharacter) throws
    func remove(_ character: RMCharacter) throws
    func getAllCharacters() -> [RMCharacter]
    func getCharacterById(id: Int) -> RMCharacter?
    func isFavorite(_ character: RMCharacter) -> Bool
}

final class FavoriteStorageServiceDefault: FavoriteStorageService {
    
    private let realm: Realm
    
    init() throws {
        self.realm = try Realm()
    }
    
    func add(_ character: RMCharacter) throws {
        let object = RealmCharacter(from: character)
        do {
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch {
            throw RealmError.writeError(error)
        }
    }
    
    func remove(_ character: RMCharacter) throws {
        guard let object = realm.object(ofType: RealmCharacter.self, forPrimaryKey: character.id)
        else { throw RealmError.notFound }
        
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            throw RealmError.writeError(error)
        }
    }
    
    func getAllCharacters() -> [RMCharacter] {
            let characters = realm.objects(RealmCharacter.self)
            return Array(characters).map{ RMCharacter(from: $0)}
        }
    
    func getCharacterById(id: Int) -> RMCharacter? {
            guard let realmCharacter = realm.object(ofType: RealmCharacter.self, forPrimaryKey: id) else { return nil }
            return RMCharacter(from: realmCharacter)
        }
    
    func isFavorite(_ character: RMCharacter) -> Bool {
        return realm.object(ofType: RealmCharacter.self, forPrimaryKey: character.id) != nil
    }
}

enum RealmError: Error {
    case notFound
    case writeError(Error)
    case readError(Error)
    case initializationError(Error)
}

extension RealmError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Character not found in favorites"
        case .writeError(let error):
            return "Failed to write to database: \(error.localizedDescription)"
        case .readError(let error):
            return "Failed to read from database: \(error.localizedDescription)"
        case .initializationError(let error):
            return "Failed to initialize database: \(error.localizedDescription)"
        }
    }
}
