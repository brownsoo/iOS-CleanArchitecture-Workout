//
//  PagedList.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct PagedList<Item: Identifiable> {
    /// available total count of items
    var totalCount: Int
    var page: Int
    var totalPages: Int
    var items: [Item]
}
