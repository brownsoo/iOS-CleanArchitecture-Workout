//
//  NetworkError.swift
//  MarvelVillain
//
//  Created by hyonsoo on 2023/08/25.
//

import Foundation

public enum NetworkError: Error {
    case unauthorized
    case networkDisconnected
    case networkError(statusCode: Int?, cause: Error, data: Data?)
    case contentNotChanged
    case urlGenerate(urlString: String)
    case emptyResponse
    case parsing(cause: Error, model: String)
    case errorResponse(statusCode: Int, message: String?)
}


public extension Error {
    var asNetworkError: NetworkError? {
        self as? NetworkError
    }
}

extension NetworkError : HumanReadable {
    public func humanMessage() -> String {
        switch self {
        case .unauthorized:
            return "미인증 요청이네요."
        case .networkDisconnected:
            return "인터넷 연결이 필요합니다."
        case .networkError(let statusCode, let cause, _):
            return "[\(statusCode?.description ?? "nil")] \(cause.localizedDescription)"
        case .contentNotChanged:
            return "컨텐츠 변경이 없음."
        case .urlGenerate(let urlString):
            return "주소 형식이 맞지 않아요.\n\(urlString)"
        case .emptyResponse:
            return "데이터 없음"
        case .parsing(let cause, let model):
            return "\(model)파싱 오류\n\(cause)"
        case .errorResponse(let statusCode, let message):
            return "[\(statusCode)] \(message ?? "")"
        }
    }
}
