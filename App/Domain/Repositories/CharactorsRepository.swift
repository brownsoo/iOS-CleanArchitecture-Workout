//
//  CharactorsRepository.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

protocol CharactorsRepository {
    func fetch(page: Int) async throws -> [MarvelCharacter]
    func get(id: Int) async throws -> MarvelCharacter?
}
