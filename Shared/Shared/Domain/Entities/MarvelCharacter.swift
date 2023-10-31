//
//  MarvelCharacter.swift
//  MarvelVillain
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

public struct MarvelCharacter: Identifiable {
    public let id: Int
    public let name: String
    public let description: String
    /// The canonical URL identifier for this resource.
    public let resourceURI: URL?
    public let urls: [MarvelUrl]
    public let thumbnail: URL?
    public let comics: MarvelResourceList
    public let stories: MarvelResourceList
    public let events: MarvelResourceList
    public let series: MarvelResourceList
    public var isFavorite: Bool? = nil
    public var favoritedAt: Date? = nil
    
    public init(id: Int, name: String, description: String, resourceURI: URL?, urls: [MarvelUrl], thumbnail: URL?, comics: MarvelResourceList, stories: MarvelResourceList, events: MarvelResourceList, series: MarvelResourceList, isFavorite: Bool? = nil, favoritedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.resourceURI = resourceURI
        self.urls = urls
        self.thumbnail = thumbnail
        self.comics = comics
        self.stories = stories
        self.events = events
        self.series = series
        self.isFavorite = isFavorite
        self.favoritedAt = favoritedAt
    }
}
