//
//  NetworkDataService.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/25.
//

import Foundation

/// 네트워크에서 데이터 모델을 제공 
protocol NetworkDataService {
    func request<T>(_ resource: any NetworkRequest<T>) async throws -> T where T: Decodable
}

final class DefaultNetworkDataService {
    private let client: NetworkClient
    private let decoder: ResponseDecoder
    
    init(client: NetworkClient,
         decoder: ResponseDecoder) {
        self.client = client
        self.decoder = decoder
    }
}

extension DefaultNetworkDataService: NetworkDataService {
    func request<T>(_ resource: any NetworkRequest<T>) async throws -> T where T: Decodable {
        let res = try await self.client.request(resource)
        if res.status == 304 {
            throw NetworkError.contentNotChanged
        }
        guard let data = res.data else {
            throw NetworkError.emptyResponse
        }
        let model: T = try self.decoder.decode(data)
        return model
    }
}
