//
//  MarvelComic.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/25.
//

import Foundation

struct MarvelComic: Identifiable {
    let id: Int
    let digitalId: Int
    let title: String
    let description: String
    /// The publication format of the comic e.g. comic, hardcover, trade paperback.
    let format: String
    /// The number of story pages in the comic.,
    let pageCount: Int
    /// The canonical URL identifier for this resource.
    let resourceURI: URL?
    ///  A set of public web site URLs for the resource.,
    let urls: [URL]
    let thumbnail: URL?
    let images: [URL]
    let creators: MarvelResourceList
    let comics: MarvelResourceList
    let stories: MarvelResourceList
    let events: MarvelResourceList
    let series: MarvelResourceList
}

extension MarvelComic: Equatable {
    static func ==(lhs: MarvelComic, rhs: MarvelComic) -> Bool {
        return lhs.id == rhs.id
    }
}


