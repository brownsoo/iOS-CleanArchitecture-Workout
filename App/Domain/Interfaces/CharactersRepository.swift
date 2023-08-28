//
//  CharactersRepository.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

protocol CharactersRepository {
    func fetchList(page: Int,
                   onCached: @escaping(PagedData<MarvelCharacter>?) -> Void,
                   onFetched: @escaping (Result<PagedData<MarvelCharacter>, Error>) -> Void
    ) -> Cancellable
    
    func getCharacter(id: Int,
                      onResult: @escaping (Result<MarvelCharacter?, Error>) -> Void
    ) -> Cancellable
}
