//
//  ResMarvelError.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct ResMarvelError: Decodable {
    /// the http status code of the error
    let code: Int
    /// a description of the error
    let status: String
}
