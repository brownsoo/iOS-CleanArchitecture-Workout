//
//  MarvelImage.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct MarvelImage: Identifiable, Equatable {
    var id: String {
        self.path
    }
    let path: String
    let `extension`: String
}

extension MarvelImage {
    var fullPath: String {
        self.path + self.extension
    }
}
