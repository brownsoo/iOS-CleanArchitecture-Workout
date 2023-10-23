//
//  ResponseDecoder.swift
//  MarvelVillain
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}
