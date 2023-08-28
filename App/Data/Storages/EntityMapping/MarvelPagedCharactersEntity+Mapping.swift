//
//  MarvelPagedCharactersEntity+Mapping.swift
//  App
//
//  Created by hyonsoo on 2023/08/28.
//

import Foundation
import CoreData

// MARK: entity -> domain

extension MarvelPagedCharactersEntity {
    func toDomain() -> PagedData<MarvelCharacter> {
        return .init(page: Int(self.page),
                     totalCount: Int(self.totalCount),
                     totalPages: Int(self.totalPages),
                     items: self.items?.allObjects.compactMap { ($0 as? MarvelCharacterEntity)?.toDomain() } ?? [],
                     etag: self.etag
        )
    }
}

extension MarvelCharacterEntity {
    func toDomain() -> MarvelCharacter {
        return .init(
            id: Int(self.id),
            name: self.name ?? "",
            description: self.desc ?? "",
            resourceURI: self.resourceURI?.toURL(),
            urls: self.urls?.allObjects.compactMap({ ($0 as! UrlEntity).toDomain() }) ?? [],
            thumbnail: thumbnail?.toURL(),
            comics: self.comics?.toDomain() ?? MarvelResourceList(availableCount: 0),
            stories: self.stories?.toDomain() ?? MarvelResourceList(availableCount: 0),
            events: self.events?.toDomain() ?? MarvelResourceList(availableCount: 0),
            series: self.series?.toDomain() ?? MarvelResourceList(availableCount: 0))
    }
}


extension MarvelResourceListEntity {
    func toDomain() -> MarvelResourceList {
        .init(availableCount: Int(self.availableCount),
              collectionURI: self.collectionURI)
    }
}


extension UrlEntity {
    func toDomain() -> URL? {
        self.url?.toURL()
    }
}

// MARK: domain -> entity

extension MarvelResourceList {
    func toEntity(in context: NSManagedObjectContext) -> MarvelResourceListEntity {
        let entity = MarvelResourceListEntity(context: context)
        entity.availableCount = Int32(self.availableCount)
        entity.collectionURI = self.collectionURI
        return entity
    }
}

fileprivate extension URL {
    func toEntity(in context: NSManagedObjectContext) -> UrlEntity {
        let entity = UrlEntity(context: context)
        entity.url = self.absoluteString
        return entity
    }
}

extension MarvelCharacter {
    func toEntity(in context: NSManagedObjectContext) -> MarvelCharacterEntity {
        let entity = MarvelCharacterEntity(context: context)
        entity.id = Int64(self.id)
        entity.name = self.name
        entity.desc = self.description
        entity.resourceURI = self.resourceURI?.absoluteString
        self.urls.forEach {
            entity.addToUrls($0.toEntity(in: context))
        }
        entity.thumbnail = self.thumbnail?.absoluteString
        entity.comics = self.comics.toEntity(in: context)
        entity.stories = self.stories.toEntity(in: context)
        entity.events = self.events.toEntity(in: context)
        entity.series = self.series.toEntity(in: context)
        return entity
    }
    
    func toFavoritEntity(in context: NSManagedObjectContext, createdAt: Date) -> FavoriteEntity {
        let entity = FavoriteEntity(context: context)
        entity.item = self.toEntity(in: context)
        entity.createdAt = createdAt
        return entity
    }
}

extension PagedData<MarvelCharacter> {
    func toEntity(in context: NSManagedObjectContext) -> MarvelPagedCharactersEntity {
        let entity = MarvelPagedCharactersEntity(context: context)
        entity.page = Int32(self.page)
        entity.totalCount = Int32(self.totalCount)
        entity.totalPages = Int32(self.totalPages)
        self.items.forEach { it in
            entity.addToItems(it.toEntity(in: context))
        }
        entity.etag = self.etag
        return entity
    }
}
