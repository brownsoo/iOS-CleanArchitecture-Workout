//
//  NetworkResponseDecoder.swift
//  MarvelVillain
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

public protocol NetworkResponseDecoder {
    
    /// 데이터를 모델로 파싱
    /// - Parameter data: Data
    /// - Returns: 응답 모델
    /// - Throws: AppError.parsing, AppError.emptyResponse
    func decode<T: Decodable>(_ data: Data) throws -> T
}
