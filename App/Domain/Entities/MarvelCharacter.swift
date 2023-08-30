//
//  MarvelCharacter.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct MarvelCharacter: Identifiable {
    let id: Int
    let name: String
    let description: String
    /// The canonical URL identifier for this resource.
    let resourceURI: URL?
    let urls: [MarvelUrl]
    let thumbnail: URL?
    let comics: MarvelResourceList
    let stories: MarvelResourceList
    let events: MarvelResourceList
    let series: MarvelResourceList
    var isFavorite: Bool? = nil
    var favoritedAt: Date? = nil
}
