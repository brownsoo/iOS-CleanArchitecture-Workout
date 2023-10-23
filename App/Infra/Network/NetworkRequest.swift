//
//  NetworkRequest.swift
//  MarvelVillain
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

protocol NetworkRequest<ResponseType> {
    associatedtype ResponseType
    var url: URL { get }
    var headers: [String : String] { get }
    
    func toUrlRequest() throws -> URLRequest
}
