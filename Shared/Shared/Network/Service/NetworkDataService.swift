//
//  NetworkDataService.swift
//  Shared
//
//  Created by hyonsoo on 11/8/23.
//

import Foundation
/// 네트워크에서 데이터 모델을 제공
public protocol NetworkDataService {
    func request<T>(_ request: some NetworkRequest<T>) async throws -> T where T: Decodable
}
