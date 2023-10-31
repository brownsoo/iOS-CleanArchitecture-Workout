//
//  MarvelUrl.swift
//  App
//
//  Created by hyonsoo on 2023/08/31.
//

import Foundation

public struct MarvelUrl: Identifiable {
    public var id: String {
        url
    }
    public let type: String
    public let url: String
    
    public init(type: String, url: String) {
        self.type = type
        self.url = url
    }
}
