//
//  MarvelResourceList.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct MarvelResourceList<Item: Equatable & Identifiable> {
    /// The number of total available resources in this list
    let available: Int
    /// The number of resources returned in this resource list (up to 20).
    let returned: Int
    /// The path to the list of full view representations of the items in this resource list.
    let collectionURI: String
    /// A list of summary views of the items in this resource list.
    let items: [Item]
}
