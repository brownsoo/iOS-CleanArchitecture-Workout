//
//  CoreDataStorage.swift
//  App
//
//  Created by hyonsoo on 2023/08/27.
//

import Foundation
import CoreData

final class CoreDataStorage {
    static let shared = CoreDataStorage()
    
    private init(){}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataStorage")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: report error to cloud
                assertionFailure("CoreDataStorage 오류 \(error), \(error.userInfo)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: report error to cloud
                assertionFailure("CoreDataStorage 오류 \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async rethrows -> T {
        return try await persistentContainer.performBackgroundTask(block)
    }
}
