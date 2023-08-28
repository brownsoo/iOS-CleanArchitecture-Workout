//
//  PagedList.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct PagedData<Item: Identifiable> {
    var page: Int
    /// available total count of items
    var totalCount: Int
    var totalPages: Int
    var items: [Item]
    var etag: String?
}
