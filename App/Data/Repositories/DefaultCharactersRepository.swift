//
//  DefaultCharacterRepository.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

final class DefaultCharactersRepository {
    private let dataService: NetworkDataService
    private let cache: CharactersStorage
    
    init(dataService: NetworkDataService, cache: CharactersStorage) {
        self.dataService = dataService
        self.cache = cache
    }
}

extension DefaultCharactersRepository: CharactersRepository {
    
    func fetchList(page: Int,
                   onCached: @escaping (PagedData<MarvelCharacter>?) -> Void,
                   onFetched: @escaping (Result<PagedData<MarvelCharacter>, Error>) -> Void) -> Cancellable {
        let task = Task { [weak self] in
            guard let this = self else { return }
            // FXIME: ignores error?
            let cached = try? await this.cache.getData(page: page)
            onCached(cached)
            do {
                let results = try await this.dataService.request(MarvelApi.character.search(page: page, limit: kQueryLimit, etag: cached?.etag))
                guard !Task.isCancelled else {
                    return
                }
                let paged = results.toPagedData()
                await this.cache.save(data: paged)
                onFetched(.success(paged))
            } catch {
                onFetched(.failure(error))
            }
        }
        return task
    }
    
    func getCharacter(id: Int, onResult: @escaping (Result<MarvelCharacter?, Error>) -> Void) -> Cancellable {
        let task = Task { [weak self] in
            guard let this = self else { return }
            if let cached = try? await this.cache.getCharactor(id: id) {
                onResult(.success(cached))
                return
            }
            do {
                let resResults = try await this.dataService.request(
                    MarvelApi.character.get(characterId: id)
                )
                guard !Task.isCancelled else {
                    return
                }
                let fetched = resResults.data.results.first?.toDomain()
                onResult(.success(fetched))
            } catch {
                onResult(.failure(error))
            }
        }
        return task
    }
    
}
