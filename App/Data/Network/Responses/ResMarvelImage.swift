//
//  ResMarvelImage.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct ResMarvelImage: Decodable {
    let path: String
    let `extension`: String
}

extension ResMarvelImage {
    var fullPath: String {
        self.path + self.extension
    }
}
