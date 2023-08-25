//
//  ApiEndpoint.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/25.
//

import Foundation

protocol ApiEndpoint {
    var urlString: String { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
}
