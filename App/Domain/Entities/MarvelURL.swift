//
//  URLs.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct MarvelURL: Equatable, Identifiable {
    
    var id: String {
        url
    }
    
    let type: String
    let url: String
}
