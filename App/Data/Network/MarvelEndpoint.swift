//
//  MarvelEndpoint.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct MarvelEndpoint: ApiEndpoint {
    private let apiHost = kMarvelApiHost
    private let apiKey = kMarvelPublicKey
    let urlString: String
    var headers: [String : String]
    var parameters: [String : Any]?
    
    init(_ path: String, parameters: [String : Any]? = nil) {
        self.urlString = "\(apiHost)\(path)"
        self.headers = [:]
        self.headers["Content-Type"] = "application/json"
        var params = parameters ?? [:]
        params["apiKey"] = apiKey
        self.parameters = params
    }
}
