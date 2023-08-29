//
//  CharactersListItemViewModel.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import Foundation

class CharactersListItemViewModel: NSObject, Identifiable {
    
    let id: Int
    let name: String
    let thumbnail: URL?
    let urlsCount: Int
    let comicsCount: Int
    let storiesCount: Int
    let eventsCount: Int
    let seriesCount: Int
    private(set) var isFavorite: Bool
    private(set) var favoritedAt: Date?
    
    init(id: Int, name: String, thumbnail: URL? = nil, urlsCount: Int, comicsCount: Int, storiesCount: Int, eventsCount: Int, seriesCount: Int, isFavorite: Bool, favoritedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.urlsCount = urlsCount
        self.comicsCount = comicsCount
        self.storiesCount = storiesCount
        self.eventsCount = eventsCount
        self.seriesCount = seriesCount
        self.isFavorite = isFavorite
        self.favoritedAt = favoritedAt
    }
    
    func markFavorite(_ value: Bool, at: Date? = nil) {
        self.isFavorite = value
        self.favoritedAt = at
    }
    
    static func == (lhs: CharactersListItemViewModel,
                    rhs: CharactersListItemViewModel) -> Bool {
        return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.thumbnail == rhs.thumbnail
        && lhs.urlsCount == rhs.urlsCount
        && lhs.comicsCount == rhs.comicsCount
        && lhs.storiesCount == rhs.storiesCount
        && lhs.eventsCount == rhs.eventsCount
        && lhs.seriesCount == rhs.seriesCount
        && lhs.isFavorite == rhs.isFavorite
        && lhs.favoritedAt == rhs.favoritedAt
    }
}

extension CharactersListItemViewModel {
    convenience init(character: MarvelCharacter) {
        self.init(
            id : character.id,
            name : character.name,
            thumbnail : character.thumbnail,
            urlsCount : character.urls.count,
            comicsCount : character.comics.availableCount,
            storiesCount : character.stories.availableCount,
            eventsCount : character.events.availableCount,
            seriesCount : character.series.availableCount,
            isFavorite : character.isFavorite == true,
            favoritedAt : character.favoritedAt
        )
    }
}
