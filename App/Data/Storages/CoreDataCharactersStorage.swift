//
//  CoreDataCharactersStorage.swift
//  App
//
//  Created by hyonsoo on 2023/08/28.
//

import Foundation
import CoreData

final class CoreDataCharactersStorage {
    private let dataStorage: CoreDataStorage
    
    init(dataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.dataStorage = dataStorage
    }
    
    private func fetchRequest(page: Int) -> NSFetchRequest<MarvelPagedCharactersEntity> {
        let request: NSFetchRequest = MarvelPagedCharactersEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %d",
                                        #keyPath(MarvelPagedCharactersEntity.page),
                                        Int32(page))
        return request
    }
    
    private func fetchRequest(characterId: Int) -> NSFetchRequest<MarvelCharacterEntity> {
        let request: NSFetchRequest = MarvelCharacterEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %d", Int64(characterId))
        return request
    }
    
    private func deleteCharacters(page: Int, in context: NSManagedObjectContext) throws {
        let request = fetchRequest(page: page)
        if let result = try context.fetch(request).first {
            context.delete(result)
        }
    }
}

extension CoreDataCharactersStorage: CharactersStorage {
    func getData(page: Int) async throws -> PagedData<MarvelCharacter>? {
        do {
            let data: PagedData<MarvelCharacter>? = try await dataStorage.performBackgroundTask { context in
                let request = self.fetchRequest(page: page)
                let entity = try context.fetch(request).first
                return entity?.toDomain()
            }
            return data
        } catch {
            throw AppError.runtime(cause: error, message: error.localizedDescription)
        }
    }
    
    func getCharactor(id: Int) async throws -> MarvelCharacter? {
        do {
            let data: MarvelCharacter? = try await dataStorage.performBackgroundTask({ context in
                let request = self.fetchRequest(characterId: id)
                let entity = try context.fetch(request).first
                return entity?.toDomain()
            })
            return data
        } catch {
            throw AppError.runtime(cause: error, message: error.localizedDescription)
        }
    }
    
    func save(data: PagedData<MarvelCharacter>) async {
        do {
            try await dataStorage.performBackgroundTask { context in
                // try self.deleteCharacters(page: data.page, in: context)
                let entity = data.toEntity(in: context)
                try context.save()
            }
        } catch {
            //  TODO : log to cloud
            debugPrint("CoreDataCharactersStorage :: \(error), \((error as NSError).userInfo)")
        }
    }
    
    
}
