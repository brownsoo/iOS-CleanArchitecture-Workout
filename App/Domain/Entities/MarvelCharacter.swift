//
//  Character.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct MarvelCharacter: Identifiable {
    let id: Int
    let name: String
    let description: String
    let modified: Date?
    /// The canonical URL identifier for this resource.
    let resourceURI: String
    let urls: [MarvelURL]
    let thumbnail: MarvelImage
//    let comics: MarvelResourceList<MarvelComic>
//    let stories: MarvelResourceList<MarvelStory>
//    let events: MarvelResourceList<MarvelStory>
//    let series: MarvelResourceList<MarvelSerise>
}

extension MarvelCharacter: Equatable {
    static func ==(lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
        return lhs.id == rhs.id
    }
}
