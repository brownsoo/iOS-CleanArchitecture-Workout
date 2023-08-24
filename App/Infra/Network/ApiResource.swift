//
//  ApiResource.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

protocol ApiEndpoint {
    var urlString: String { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
}

struct ApiResource<A>: Resource {
    let endpoint: ApiEndpoint
    let method: HttpMethod
    let body: Data?
    let file: URL?
    
    var headers: [String: String] {
        endpoint.headers
    }
    
    var url: URL {
        URL(string: endpoint.urlString + paramsAppendix())!
    }
    
    
    init(_ endpoint: ApiEndpoint,
         method: HttpMethod = .get,
         body: Data? =  nil,
         file: URL? = nil
    ) {
        self.endpoint = endpoint
        self.method = method
        self.body = body
        self.file = file
    }
    
    private func paramsAppendix() -> String {
        guard let params = endpoint.parameters else {
            return ""
        }
        return "?\(params.map { "\($0.key)=\($0.value)" }.joined(separator: "&"))"
    }
}
