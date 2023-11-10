//
//  ResMarvelComic.swift
//  MarvelVillain
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation
import Shared

struct ResMarvelComic: Decodable {
    let id: Int
    /// The ID of the digital comic representation of this comic. Will be 0 if the comic is not available digitally.,
    let digitalId: Int
    /// The canonical title of the comic.,
    let title: String
    /// The number of the issue in the series (will generally be 0 for collection formats).,
    let issueNumber: Double?
    /// If the issue is a variant (e.g. an alternate cover, second printing, or director’s cut), a text description of the variant.,
    let variantDescription: String?
    /// The preferred description of the comic.,
    let description: String
    /// The date the resource was most recently modified., ex) 2014-04-29T14:18:17-0400
    let modified: Date
    /// The ISBN for the comic (generally only populated for collection formats).,
    let isbn: String?
    /// The UPC barcode number for the comic (generally only populated for periodical formats).,
    let upc: String?
    /// The Diamond code for the comic.,
    let diamondCode: String?
    /// The EAN barcode for the comic.,
    let ean: String?
    /// The ISSN barcode for the comic.,
    let issn: String?
    /// The publication format of the comic e.g. comic, hardcover, trade paperback.,
    let format: String
    /// The number of story pages in the comic.,
    let pageCount: Int
    /// A set of descriptive text blurbs for the comic.,
    let textObjects: [ResMarvelText]
    let resourceURI: String
    ///  A set of public web site URLs for the resource.,
    let urls: [ResMarvelURL]
    
    let thumbnail: ResMarvelImage
    let images: [ResMarvelImage]
    let creators: ResMarvelResourceList<ResMarvelCreatorSummary>
    let comics: ResMarvelResourceList<ResMarvelComicSummary>
    let stories: ResMarvelResourceList<ResMarvelStorySummary>
    let events: ResMarvelResourceList<ResMarvelEventSummary>
    let series: ResMarvelResourceList<ResMarvelSeriesSummary>
}

extension ResMarvelComic {
    func toDomain() -> MarvelComic {
        MarvelComic(id: self.id,
                    digitalId: self.digitalId,
                    title: self.title,
                    description: self.description,
                    format: self.format,
                    pageCount: self.pageCount,
                    resourceURI: URL(string: self.resourceURI),
                    urls: self.urls.compactMap({ URL(string: $0.url) }),
                    thumbnail: URL(string: self.thumbnail.fullPath),
                    images: self.images.compactMap({ URL(string: $0.fullPath) }),
                    creators: self.creators.toDomain(),
                    comics: self.comics.toDomain(),
                    stories: self.stories.toDomain(),
                    events: self.events.toDomain(),
                    series: self.series.toDomain())
    }
}
