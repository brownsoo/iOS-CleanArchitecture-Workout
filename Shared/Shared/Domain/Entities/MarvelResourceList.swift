//
//  MarvelResourceList.swift
//  MarvelVillain
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

public struct MarvelResourceList: Equatable {
    public let availableCount: Int
    public var collectionURI: String?
    
    public init(availableCount: Int, collectionURI: String? = nil) {
        self.availableCount = availableCount
        self.collectionURI = collectionURI
    }
}
