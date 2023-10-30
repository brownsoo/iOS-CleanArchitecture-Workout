//
//  HttpEndpoint.swift
//  MarvelVillain
//
//  Created by hyonsoo on 2023/08/25.
//

import Foundation

public protocol NetworkEndpoint {
    var urlString: String { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
}
