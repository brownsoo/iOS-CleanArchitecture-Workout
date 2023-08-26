//
//  DefaultCharacterRepository.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

final class DefaultCharacterRepository {
    private let dataService: NetworkDataService
    private let cache: CharacterStorage
    
    init(dataService: NetworkDataService, cache: CharacterStorage) {
        self.dataService = dataService
        self.cache = cache
    }
}

extension DefaultCharacterRepository: CharactorsRepository {
    
    func fetchList(page: Int,
                   onCached: @escaping (PagedData<MarvelCharacter>) -> Void,
                   onFetched: @escaping (Result<PagedData<MarvelCharacter>, Error>) -> Void) -> Cancellable {
        // TODO: cache 조회 전달, 리모트 etag 체크 -> 다르면 요청 후 패치 전달
        let task = Task { [weak self] in
            guard let this = self else { return }
            let cached = await this.cache.getData(page: page)
            onCached(cached)
            do {
                let resResults = try await this.dataService.request(MarvelApi.character.search(page: page, limit: kQueryLimit, etag: cached.etag))
                guard !Task.isCancelled else {
                    return
                }
                let paged = resResults.toPagedData()
                await this.cache.save(data: paged)
                onFetched(.success(paged))
            } catch {
                onFetched(.failure(error))
            }
        }
        return task
    }
    
    func get(id: Int, onResult: @escaping (MarvelCharacter?) -> Void) -> Cancellable {
        let task = Task { () -> MarvelCharacter? in
            return nil
        }
        return task
    }
    
}
