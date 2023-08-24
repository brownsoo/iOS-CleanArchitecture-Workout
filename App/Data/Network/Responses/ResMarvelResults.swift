//
//  ResMarvelResults.swift
//  KisTest
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
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [T]
}
