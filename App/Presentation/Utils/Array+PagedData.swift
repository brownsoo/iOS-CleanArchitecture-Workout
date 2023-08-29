//
//  Array+PagedData.swift
//  App
//
//  Created by hyonsoo on 2023/08/30.
//

import Foundation

extension Array where Element == PagedData<MarvelCharacter> {
    var characters: [MarvelCharacter] {
        self.flatMap { $0.items }
    }
}
