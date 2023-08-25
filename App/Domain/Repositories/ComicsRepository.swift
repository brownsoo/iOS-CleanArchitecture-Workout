//
//  ComicsRepository.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

protocol ComicsRepository {
    func fetch(page: Int) async throws -> [MarvelComic]
    func get(id: Int) async throws -> MarvelComic?
}
