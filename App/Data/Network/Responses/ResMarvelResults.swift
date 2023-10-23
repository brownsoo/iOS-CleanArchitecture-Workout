//
//  ResMarvelResults.swift
//  MarvelVillain
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct ResMarvelResults<T: Decodable>: Decodable {
    
    let code: Int
    let status: String
    let data: ResMarvelContainer<T>
    let etag: String
}

struct ResMarvelContainer<T: Decodable>: Decodable {
    var offset: Int
    var limit: Int
    var total: Int
    var count: Int
    var results: [T]
}

extension ResMarvelContainer {
    /// 1~n
    func getPage() -> Int {
        (offset / limit) + 1
    }
    /// 0~n
    func getTotalPages() -> Int {
        Int(ceil(Double(total) / Double(limit)))
    }
}

extension ResMarvelResults<ResMarvelCharacter> {
    func toPagedData() -> PagedData<MarvelCharacter> {
        return PagedData(page: data.getPage(),
                         totalCount: data.total,
                         totalPages: data.getTotalPages(),
                         items: data.results.map { $0.toDomain() },
                         etag: etag)
    }
}

extension ResMarvelResults<ResMarvelComic> {
    func toPagedData() -> PagedData<MarvelComic> {
        return PagedData(page: data.getPage(),
                         totalCount: data.total,
                         totalPages: data.getTotalPages(),
                         items: data.results.map { $0.toDomain() },
                         etag: etag)
    }
}
