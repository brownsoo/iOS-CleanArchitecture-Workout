//
//  CharactersRepository.swift
//  MarvelVillain
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation
import Combine

protocol CharactersRepository {
    
    /// 페이지 단위로 캐릭터를 가져옴
    /// - Parameters:
    ///   - page: 페이지 단위 1 ~ n
    ///   - refreshing: etag 를 사용하지 않고, 데이터를 가져옴.
    ///   - onCached: 캐시 스토리지에서 데이터를 가져옴.
    ///   - onFetched: 데이터 서비스에서 가져옴.
    /// - Returns: Task
    func fetchList(page: Int,
                   refreshing: Bool,
                   onCached: @escaping(PagedData<MarvelCharacter>?) -> Void,
                   onFetched: @escaping (Result<PagedData<MarvelCharacter>, Error>) -> Void
    ) -> Cancellable
    
    
    /// 캐시 우선으로 캐릭터 데이터를 조회.
    /// - Parameters:
    ///   - id: 캐릭터 아이디 1~n
    ///   - onResult: 캐릭터 데이터 결과
    /// - Returns: Task
    func getCharacter(id: Int,
                      onResult: @escaping (Result<MarvelCharacter?, Error>) -> Void
    ) -> Cancellable
    
    
    func getFavoriteList(page: Int,
                         onResult: @escaping (Result<PagedData<MarvelCharacter>, Error>) -> Void
    ) -> Cancellable
    
    func favorite(character: MarvelCharacter,
                  onResult: @escaping (Result<Bool, Error>) -> Void
    ) -> Cancellable
    
    func unfavorite(character: MarvelCharacter,
                    onResult: @escaping (Result<Bool, Error>) -> Void
    ) -> Cancellable
}
