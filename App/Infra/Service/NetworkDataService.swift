//
//  NetworkDataService.swift
//  MarvelVillain
//
//  Created by hyonsoo on 2023/08/25.
//

import Foundation
import Shared

/// 네트워크에서 데이터 모델을 제공
protocol NetworkDataService {
    func request<T>(_ request: some NetworkRequest<T>) async throws -> T where T: Decodable
}

final class DefaultNetworkDataService {
    private let client: NetworkClient
    private let decoder: NetworkResponseDecoder
    
    init(client: NetworkClient,
         decoder: NetworkResponseDecoder) {
        self.client = client
        self.decoder = decoder
    }
}

extension DefaultNetworkDataService: NetworkDataService {
    func request<T>(_ request: some NetworkRequest<T>) async throws -> T where T: Decodable {
        do {
            let res = try await self.client.request(request)
            let model: T = try self.decoder.decode(res.data)
            return model
        } catch {
            if case NetworkError.networkError(_, _, let data) = error,
               let errorBody = data,
               let res = try? JSONDecoder().decode(ResMarvelError.self, from: errorBody) {
                throw AppError.requestFailed(statusCode: res.code, message: res.status)
            }
            throw error
        }
    }
}
