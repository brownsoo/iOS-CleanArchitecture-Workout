//
//  CharacterStorage.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

protocol CharactersStorage {
    func getData(page: Int) async throws -> PagedData<MarvelCharacter>?
    func getCharactor(id: Int) async throws -> MarvelCharacter?
    func save(data: PagedData<MarvelCharacter>) async -> Void
}

