//
//  FavoritesChanges.swift
//  Shared
//
//  Created by hyonsoo on 11/14/23.
//

/// 좋아요 변경 사항
public struct FavoritesChanges {
    public let sender: String
    public let ids: [Int]
    
    public init(sender: String, ids: [Int]) {
        self.sender = sender
        self.ids = ids
    }
}
