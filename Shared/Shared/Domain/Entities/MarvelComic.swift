//
//  MarvelComic.swift
//  MarvelVillain
//
//  Created by hyonsoo on 2023/08/25.
//

import Foundation

public struct MarvelComic: Identifiable {
    public let id: Int
    public let digitalId: Int
    public let title: String
    public let description: String
    /// The publication format of the comic e.g. comic, hardcover, trade paperback.
    public let format: String
    /// The number of story pages in the comic.,
    public let pageCount: Int
    /// The canonical URL identifier for this resource.
    public let resourceURI: URL?
    ///  A set of public web site URLs for the resource.,
    public let urls: [URL]
    public let thumbnail: URL?
    public let images: [URL]
    public let creators: MarvelResourceList
    public let comics: MarvelResourceList
    public let stories: MarvelResourceList
    public let events: MarvelResourceList
    public let series: MarvelResourceList
    
    public init(id: Int, digitalId: Int, title: String, description: String, format: String, pageCount: Int, resourceURI: URL?, urls: [URL], thumbnail: URL?, images: [URL], creators: MarvelResourceList, comics: MarvelResourceList, stories: MarvelResourceList, events: MarvelResourceList, series: MarvelResourceList) {
        self.id = id
        self.digitalId = digitalId
        self.title = title
        self.description = description
        self.format = format
        self.pageCount = pageCount
        self.resourceURI = resourceURI
        self.urls = urls
        self.thumbnail = thumbnail
        self.images = images
        self.creators = creators
        self.comics = comics
        self.stories = stories
        self.events = events
        self.series = series
    }
}
