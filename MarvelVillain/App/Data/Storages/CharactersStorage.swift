//
//  CharacterStorage.swift
//  MarvelVillain
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation
import Shared

protocol CharactersStorage {
    func getCharactors(ids: [Int]) async throws -> [MarvelCharacter]
    func getCharactors(page: Int) async throws -> PagedData<MarvelCharacter>?
    func getCharactor(id: Int) async throws -> MarvelCharacter?
    func save(data: PagedData<MarvelCharacter>) async -> Void
    
    func getAllFavorites() async throws -> [MarvelCharacter]
    func getFavorites(ids: [Int]) async throws -> [MarvelCharacter]
    func getFavorites(page: Int) async throws -> PagedData<MarvelCharacter>
    func saveFavorite(data: MarvelCharacter) async throws -> Void
    func removeFavorite(data: MarvelCharacter) async throws -> Void
}

