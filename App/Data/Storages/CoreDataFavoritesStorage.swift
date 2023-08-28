//
//  CoreDataFavoritesStorage.swift
//  App
//
//  Created by hyonsoo on 2023/08/28.
//

import Foundation
import CoreData

final class CoreDataFavoritesStorage {
    private let dataStorage: CoreDataStorage
    private let queryLimit: Int
    
    init(dataStorage: CoreDataStorage = CoreDataStorage.shared,
         queryLimit: Int = kQueryLimit) {
        self.dataStorage = dataStorage
        self.queryLimit = queryLimit
    }
    
    private func fetchRequest(page: Int) -> NSFetchRequest<FavoriteEntity> {
        let request: NSFetchRequest = FavoriteEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(FavoriteEntity.createdAt), ascending: false)
        ]
        request.fetchLimit = queryLimit
        request.fetchOffset = page * queryLimit
        return request
    }
    
    private func getTotal() async -> Int {
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

extension CoreDataFavoritesStorage: FavoritesStorage {
    func getData(page: Int) async throws -> PagedData<MarvelCharacter> {
        do {
            let data: [MarvelCharacter] = try await dataStorage.performBackgroundTask({ context in
                let request = self.fetchRequest(page: page)
                let entities = try context.fetch(request)
                return entities.compactMap({ $0.item?.toDomain() })
            })
            let total = await getTotal()
            return .init(page: page,
                         totalCount: total,
                         totalPages: Int(ceil(Double(total) / Double(page))),
                         items: data)
        } catch {
            throw AppError.runtime(cause: error, message: error.localizedDescription)
        }
    }
    
    func save(data: MarvelCharacter) async throws -> Void {
        do {
            try await dataStorage.performBackgroundTask({ context in
                let entity = data.toFavoritEntity(in: context, createdAt: Date())
                try context.save()
            })
        } catch {
            //  TODO : log to cloud
            debugPrint("CoreDataFavoritesStorage :: \(error), \((error as NSError).userInfo)")
            throw error
        }
    }
    
    func remove(data: MarvelCharacter) async throws -> Void {
        do {
            try await dataStorage.performBackgroundTask({ context in
                let request: NSFetchRequest = FavoriteEntity.fetchRequest()
                request.predicate = NSPredicate(
                    format: "$K = %d",
                    #keyPath(FavoriteEntity.characterId),
                    Int64(data.id)
                )
                if let result = try context.fetch(request).first {
                    context.delete(result)
                }
            })
        } catch {
            //  TODO : log to cloud
            debugPrint("CoreDataFavoritesStorage :: \(error), \((error as NSError).userInfo)")
            throw error
        }
    }
    
}
