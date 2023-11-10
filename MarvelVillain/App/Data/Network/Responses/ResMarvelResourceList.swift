//
//  MarvelResourceList.swift
//  MarvelVillain
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation
import Shared

protocol ResMarvelResourceItem: Decodable {
    var resourceURI: String { get }
    var name: String? { get }
}

struct ResMarvelResourceList<Item: ResMarvelResourceItem>: Decodable {
    /// The number of total available resources in this list
    let available: Int
    /// The number of resources returned in this resource list (up to 20).
    let returned: Int
    /// The path to the list of full view representations of the items in this resource list.
    let collectionURI: String
    /// A list of summary views of the items in this resource list.
    let items: [Item]
}

extension ResMarvelResourceList {
    func toDomain() -> MarvelResourceList {
        MarvelResourceList(availableCount: self.available, collectionURI: self.collectionURI)
    }
}

struct ResMarvelCreatorSummary: ResMarvelResourceItem {
    var resourceURI: String
    var name: String?
    var role: String
    
}


struct ResMarvelComicSummary: ResMarvelResourceItem {
    var resourceURI: String
    var name: String?
}

struct ResMarvelStorySummary: ResMarvelResourceItem {
    var resourceURI: String
    var name: String?
    /// The type of the story (interior or cover).
    var type: String?
}

struct ResMarvelEventSummary: ResMarvelResourceItem {
    var resourceURI: String
    var name: String?
}

struct ResMarvelSeriesSummary: ResMarvelResourceItem {
    var resourceURI: String
    var name: String?
}
