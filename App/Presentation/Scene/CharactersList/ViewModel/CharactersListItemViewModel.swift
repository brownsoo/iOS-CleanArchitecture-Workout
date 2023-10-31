//
//  CharactersListItemViewModel.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import Foundation
import Shared

struct CharactersListItemViewModel: Identifiable, Equatable, Hashable {
    
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
    
    mutating func markFavorite(_ value: Bool, at: Date? = nil) {
        self.isFavorite = value
        self.favoritedAt = at
    }
}

extension CharactersListItemViewModel {
    init(character: MarvelCharacter) {
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
