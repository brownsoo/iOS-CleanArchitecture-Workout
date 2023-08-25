//
//  ApiResourceDataService.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/25.
//

import Foundation

protocol ApiResourceDataService {
    func request<T>(_ resource: ApiResource<T>) async throws -> T where T: Decodable
}

final class DefaultApiResourceDataService {
    private let client: NetworkClient
    private let decoder: ResponseDecoder
    
    init(client: NetworkClient = DefaultNetworkClient(),
         decoder: ResponseDecoder = JSONResponseDecoder()) {
        self.client = client
        self.decoder = decoder
    }
}

extension DefaultApiResourceDataService: ApiResourceDataService {
    func request<T>(_ resource: ApiResource<T>) async throws -> T where T: Decodable {
        let data = try await self.client.request(resource)
        let model: T = try self.decoder.decode(data)
        return model
    }
}
