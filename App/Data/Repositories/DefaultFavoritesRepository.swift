//
//  DefaultFavoritesRepository.swift
//  App
//
//  Created by hyonsoo on 2023/08/28.
//

import Foundation

final class DefaultFavoritesRepository {
    private let cache: FavoritesStorage
    
    init(cache: FavoritesStorage) {
        self.cache = cache
    }
}

extension DefaultFavoritesRepository: FavoritesRepository {
    
    func getList(page: Int,
                 onResult: @escaping (Result<PagedData<MarvelCharacter>, Error>) -> Void) -> Cancellable {
        let task = Task { [weak self] in
            guard let this = self else { return }
            do {
                let cached = try await this.cache.getData(page: page)
                onResult(.success(cached))
            } catch {
                onResult(.failure(error))
            }
        }
        return task
    }
    
    func favorite(character: MarvelCharacter) -> Cancellable {
        let task = Task { [weak self] in
            guard let this = self else { return }
            try await this.cache.save(data: character)
        }
        return task
    }
    
    func unfavorite(character: MarvelCharacter) -> Cancellable {
        let task = Task { [weak self] in
            guard let this = self else { return }
            try await this.cache.remove(data: character)
        }
        return task
    }
}
