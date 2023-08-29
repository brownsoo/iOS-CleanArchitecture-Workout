//
//  CharactersListItemViewModel.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import Foundation

struct CharactersListItemViewModel: Identifiable, Equatable {
    let id: Int
    let name: String
    let thumbnail: URL?
    let urlsCount: Int
    let comicsCount: Int
    let storiesCount: Int
    let eventsCount: Int
    let seriesCount: Int
    var isFavorite: Bool
    var favoritedAt: Date?
}

extension CharactersListItemViewModel {
    init(character: MarvelCharacter) {
        self.id = character.id
        self.name = character.name
        self.thumbnail = character.thumbnail
        self.urlsCount = character.urls.count
        self.comicsCount = character.comics.availableCount
        self.storiesCount = character.stories.availableCount
        self.eventsCount = character.events.availableCount
        self.seriesCount = character.series.availableCount
        self.isFavorite = character.isFavorite == true
        self.favoritedAt = character.favoritedAt
    }
}
