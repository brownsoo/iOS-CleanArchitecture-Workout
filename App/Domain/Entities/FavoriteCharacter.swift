//
//  FavoriteCharacter.swift
//  App
//
//  Created by hyonsoo on 2023/08/28.
//

import Foundation

struct FavoriteCharacter: Identifiable {
    
    var id: TimeInterval {
        createdAt.timeIntervalSince1970
    }
    
    let createdAt: Date
    let item: MarvelCharacter
}
