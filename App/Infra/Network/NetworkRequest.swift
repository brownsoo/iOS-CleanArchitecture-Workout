//
//  NetworkRequest.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

protocol NetworkRequest {
    var url: URL { get }
    var headers: [String : String] { get }
    
    func toUrlRequest() throws -> URLRequest
}
