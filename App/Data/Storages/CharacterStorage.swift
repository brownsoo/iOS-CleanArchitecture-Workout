//
//  CharacterStorage.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

protocol CharacterStorage {
    func getData(page: Int) async -> PagedData<MarvelCharacter>
    func save(data: PagedData<MarvelCharacter>) async -> Void
}

