//
//  PagedList.swift
//  MarvelVillain
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

public struct PagedData<Item: Identifiable> {
    public var page: Int
    /// available total count of items
    public var totalCount: Int
    public var totalPages: Int
    public var items: [Item]
    public var etag: String?
    
    public init(page: Int, totalCount: Int, totalPages: Int, items: [Item], etag: String? = nil) {
        self.page = page
        self.totalCount = totalCount
        self.totalPages = totalPages
        self.items = items
        self.etag = etag
    }
}
