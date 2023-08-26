//
//  NetworkDataService.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/25.
//

import Foundation

protocol NetworkDataService {
    func request<T>(_ resource: NetworkResource<T>) async throws -> T where T: Decodable
}

final class DefaultNetworkDataService {
    private let client: NetworkClient
    private let decoder: ResponseDecoder
    
    init(client: NetworkClient = DefaultNetworkClient(),
         decoder: ResponseDecoder = JSONResponseDecoder()) {
        self.client = client
        self.decoder = decoder
    }
}

extension DefaultNetworkDataService: NetworkDataService {
    func request<T>(_ resource: NetworkResource<T>) async throws -> T where T: Decodable {
        let res = try await self.client.request(resource)
        if res.status == 304 {
            throw AppError.contentNotChanged
        }
        guard let data = res.data else {
            throw AppError.emptyResponse
        }
        let model: T = try self.decoder.decode(data)
        return model
    }
}
