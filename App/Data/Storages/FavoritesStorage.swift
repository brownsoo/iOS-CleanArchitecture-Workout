//
//  FavoritesStorage.swift
//  App
//
//  Created by hyonsoo on 2023/08/28.
//

import Foundation

protocol FavoritesStorage {
    func getData(page: Int) async throws -> PagedData<MarvelCharacter>
    func save(data: MarvelCharacter) async throws -> Void
    func remove(data: MarvelCharacter) async throws -> Void
}
