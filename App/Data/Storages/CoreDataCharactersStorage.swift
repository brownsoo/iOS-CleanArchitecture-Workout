//
//  CoreDataCharactersStorage.swift
//  App
//
//  Created by hyonsoo on 2023/08/28.
//

import Foundation
import CoreData
import Shared

actor CoreDataCharactersStorage {
    private let dataStorage: CoreDataStorage
    private let queryLimit: Int
    
    init(dataStorage: CoreDataStorage = CoreDataStorage.shared,
         queryLimit: Int = kQueryLimit) {
        self.dataStorage = dataStorage
        self.queryLimit = queryLimit
    }
    
    private func fetchCharacters(page: Int) -> NSFetchRequest<MarvelPagedCharactersEntity> {
        let request = MarvelPagedCharactersEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %d",
                                        #keyPath(MarvelPagedCharactersEntity.page),
                                        Int32(page))
        return request
    }
    
    private func fetchCharacter(characterId: Int) -> NSFetchRequest<MarvelCharacterEntity> {
        let request = MarvelCharacterEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %d",
                                        Int64(characterId))
        return request
    }
    
    private func deleteCharacters(page: Int, in context: NSManagedObjectContext) throws {
        let request = fetchCharacters(page: page)
        if let result = try context.fetch(request).first {
            context.delete(result)
        }
    }
    
    private func fetchFavorites(page: Int) -> NSFetchRequest<FavoriteEntity> {
        let request = FavoriteEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(FavoriteEntity.createdAt), ascending: false)
        ]
        request.fetchLimit = queryLimit
        request.fetchOffset = (page - 1) * queryLimit
        return request
    }
    
    private func fetchFavorites(inIds ids: [Int64]) -> NSFetchRequest<FavoriteEntity> {
        let request = FavoriteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K IN %@",
                                        #keyPath(FavoriteEntity.characterId),
                                        ids)
        return request
    }
    
    private func getFavoritesTotal() async -> Int {
        let request: NSFetchRequest = FavoriteEntity.fetchRequest()
        do {
            let count = try await dataStorage.performBackgroundTask { context in
                return try context.count(for: request)
            }
            return count
        } catch {
            debugPrint("FavoriteEntity getTotal \(error)")
            return 0
        }
    }
}

extension CoreDataCharactersStorage: CharactersStorage {
    
    func getCharactors(page: Int) async throws -> PagedData<MarvelCharacter>? {
        do {
            let data: PagedData<MarvelCharacter>? = try await dataStorage.performBackgroundTask { context in
                let request = self.fetchCharacters(page: page)
                let entity = try context.fetch(request).first
                return entity?.toDomain()
            }
            return data
        } catch {
            throw AppError.runtime(cause: error, message: error.localizedDescription)
        }
    }
    
    
    func save(data: PagedData<MarvelCharacter>) async {
        do {
            try await dataStorage.performBackgroundTask { context in
                let ids: [Int64] = data.items.map({ Int64($0.id) })
                let favoritesRequest = self.fetchFavorites(inIds: ids)
                let favorites = try context.fetch(favoritesRequest)
                
                try self.deleteCharacters(page: data.page, in: context)
                
                let _ = data.toEntity(in: context, favorites: favorites)
                try context.save()
            }
        } catch {
            //  TODO : log to cloud
            debugPrint("CoreDataCharactersStorage :: \(error), \((error as NSError).userInfo)")
        }
    }
    
    func getCharactor(id: Int) async throws -> MarvelCharacter? {
        do {
            let data: MarvelCharacter? = try await dataStorage.performBackgroundTask({ context in
                let request = self.fetchCharacter(characterId: id)
                let entity = try context.fetch(request).first
                return entity?.toDomain()
            })
            return data
        } catch {
            throw AppError.runtime(cause: error, message: error.localizedDescription)
        }
    }
    
    func getAllFavorites() async throws -> [MarvelCharacter] {
        do {
            let data: [MarvelCharacter] = try await dataStorage.performBackgroundTask({ context in
                let request = FavoriteEntity.fetchRequest()
                let entities = try context.fetch(request)
                return entities.compactMap({ $0.item?.toDomain() })
            })
            return data
        } catch {
            throw AppError.runtime(cause: error, message: error.localizedDescription)
        }
    }
    
    func getFavorites(page: Int) async throws -> PagedData<MarvelCharacter> {
        do {
            let data: [MarvelCharacter] = try await dataStorage.performBackgroundTask({ context in
                let request = self.fetchFavorites(page: page)
                let entities = try context.fetch(request)
                return entities.compactMap({ $0.item?.toDomain() })
            })
            let total = await getFavoritesTotal()
            return .init(page: page,
                         totalCount: total,
                         totalPages: Int(ceil(Double(total) / Double(page * kQueryLimit))),
                         items: data)
        } catch {
            throw AppError.runtime(cause: error, message: error.localizedDescription)
        }
    }
    
    func saveFavorite(data: MarvelCharacter) async throws {
        do {
            try await dataStorage.performBackgroundTask({ context in
                let request = self.fetchCharacter(characterId: data.id)
                if let character = try context.fetch(request).first {
                    let _ = data.toFavoritEntity(in: context,
                                                 character: character,
                                                 createdAt: Date())
                    try context.save()
                }
            })
            foot()
        } catch {
            //  TODO : log to cloud
            debugPrint("CoreDataFavoritesStorage :: \(error), \((error as NSError).userInfo)")
            throw error
        }
    }
    
    func removeFavorite(data: MarvelCharacter) async throws {
        do {
            try await dataStorage.performBackgroundTask({ context in
                let request: NSFetchRequest = FavoriteEntity.fetchRequest()
                request.predicate = NSPredicate(
                    format: "%K = %d",
                    #keyPath(FavoriteEntity.characterId),
                    Int64(data.id)
                )
                if let result = try context.fetch(request).first {
                    context.delete(result)
                    try context.save()
                }
            })
            foot()
        } catch {
            //  TODO : log to cloud
            debugPrint("CoreDataFavoritesStorage :: \(error), \((error as NSError).userInfo)")
            throw error
        }
    }
    
    
}
