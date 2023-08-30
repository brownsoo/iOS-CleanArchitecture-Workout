//
//  MarvelUrl.swift
//  App
//
//  Created by hyonsoo on 2023/08/31.
//

import Foundation

struct MarvelUrl: Identifiable {
    var id: String {
        url
    }
    let type: String
    let url: String
}
