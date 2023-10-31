//
//  Foundation+Extentions.swift
//  App
//
//  Created by hyonsoo on 2023/08/28.
//

import Foundation

public extension String {
    func toURL() -> URL? {
        URL(string: self)
    }
}

