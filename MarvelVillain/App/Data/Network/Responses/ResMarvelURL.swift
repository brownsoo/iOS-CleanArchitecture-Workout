//
//  ResMarvelURL.swift
//  MarvelVillain
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct ResMarvelURL: Decodable {
    /// A text identifier for the URL.
    let type: String
    /// A full URL (including scheme, domain, and path).
    let url: String
}
