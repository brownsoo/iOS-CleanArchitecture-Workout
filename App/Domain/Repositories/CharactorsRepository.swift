//
//  CharactorsRepository.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

protocol CharactorsRepository {
    func fetchList(page: Int,
                   onCached: @escaping(PagedData<MarvelCharacter>) -> Void,
                   onFetched: @escaping (Result<PagedData<MarvelCharacter>, Error>) -> Void
    ) -> Cancellable
    
    func get(id: Int, onResult: @escaping (MarvelCharacter?) -> Void) -> Cancellable
}
