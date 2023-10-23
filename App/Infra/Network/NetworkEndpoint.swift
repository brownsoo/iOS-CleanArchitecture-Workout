//
//  HttpEndpoint.swift
//  MarvelVillain
//
//  Created by hyonsoo on 2023/08/25.
//

import Foundation

protocol NetworkEndpoint {
    var urlString: String { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
}
