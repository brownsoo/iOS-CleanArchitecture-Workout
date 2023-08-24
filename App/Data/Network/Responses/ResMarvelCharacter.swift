//
//  ResMarvelCharacter.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct ResMarvelCharacter: Decodable {
    let id: Int
    let name: String
    let description: String
    let modified: Date?
    /// The canonical URL identifier for this resource.
    let resourceURI: String
    let urls: [ResMarvelURL]
    let thumbnail: ResMarvelImage
    let comics: ResMarvelResourceList<ResMarvelComicSummary>
    let stories: ResMarvelResourceList<ResMarvelStorySummary>
    let events: ResMarvelResourceList<ResMarvelEventSummary>
    let series: ResMarvelResourceList<ResMarvelSeriesSummary>
}

extension ResMarvelCharacter {
    func toDomain() -> MarvelCharacter {
        MarvelCharacter(id: self.id,
                        name: self.name,
                        description: self.description,
                        resourceURI: self.resourceURI,
                        urls: self.urls.map({ $0.url }),
                        thumbnail: self.thumbnail.fullPath,
                        comics: self.comics.toDomain(),
                        stories: self.stories.toDomain(),
                        events: self.events.toDomain(),
                        series: self.series.toDomain())
    }
}
