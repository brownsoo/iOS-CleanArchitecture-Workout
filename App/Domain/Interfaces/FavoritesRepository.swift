//
//  FavoritesRepository.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

protocol FavoritesRepository {
    func getList(page: Int,
                 onResult: @escaping (Result<PagedData<MarvelCharacter>, Error>) -> Void
    ) -> Cancellable
    
    func favorite(character: MarvelCharacter) throws -> Cancellable
    func unfavorite(character: MarvelCharacter) throws -> Cancellable
}
