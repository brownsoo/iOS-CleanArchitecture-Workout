//
//  AppResponse.swift
//  App
//
//  Created by hyonsoo on 10/30/23.
//

import Foundation

/// 데이터가 없는 성공 응답 모델
public struct EmptySuccessResponse: Decodable {
    
    public init(){}
    
    enum CodingKeys: CodingKey {
    }
    
    public init(from decoder: Decoder) throws {
    }
}
