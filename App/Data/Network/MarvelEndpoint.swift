//
//  MarvelEndpoint.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

struct MarvelEndpoint: NetworkEndpoint {
    private let apiHost = kMarvelApiHost
    private let apiKey = kMarvelPublicKey
    private let privateKey = kMarvelPrivateKey
    let urlString: String
    var headers: [String : String]
    var parameters: [String : Any]?
    
    init(_ path: String, etag: String? = nil, parameters: [String : Any]? = nil) {
        self.urlString = "\(apiHost)\(path)"
        self.headers = [:]
        self.headers["Content-Type"] = "application/json"
        if etag != nil {
            self.headers["If-None-Match"] = etag!
        }
        var params = parameters ?? [:]
        params["apikey"] = apiKey
        let ts = "\(Int(round(Date().timeIntervalSince1970)))"
        params["ts"] = ts
        if let hash = "\(ts)\(privateKey)\(apiKey)".hashed(.md5) {
            params["hash"] = hash
        }
        self.parameters = params
    }
}
