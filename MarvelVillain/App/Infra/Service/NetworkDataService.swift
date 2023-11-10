//
//  NetworkDataService.swift
//  MarvelVillain
//
//  Created by hyonsoo on 2023/08/25.
//

import Foundation
import Shared

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
            // 빈 데이터에 대한 오류 처리는 요청 모델(T)에 따라 성공 또는 오류가 결정된다.
            if T.self == EmptySuccessResponse.self {
                // 빈 데이터지만 성공
                return EmptySuccessResponse() as! T
            }
            guard let data = res.data else {
                // 빈 데이터 오류
                throw NetworkError.emptyResponse
            }
            let model: T = try self.decoder.decode(data)
            return model
        } catch {
            // TODO: 오류 페이로드 처리 추상화
            if case NetworkError.networkError(_, _, let data) = error,
               let errorBody = data,
               let res = try? JSONDecoder().decode(ResMarvelError.self, from: errorBody) {
                throw NetworkError.errorResponse(statusCode: res.code, message: res.status)
            }
            throw error
        }
    }
}
