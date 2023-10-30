//
//  AppError.swift
//  App
//
//  Created by hyonsoo on 10/21/23.
//

import Foundation
import Shared

enum AppError: Error {
    case runtime(cause: Error, message: String?)
    case illegalArguments
    case emptyResponse
    case parsing(cause: Error, model: String)
    case requestFailed(statusCode: Int, message: String?)
}


extension Error {
    var asAppError: AppError? {
        self as? AppError
    }
}

extension AppError : HumanReadable {
    func humanMessage() -> String {
        switch self {
        case .runtime(let cause, let message):
            return "\(message ?? "runtime") \(cause)"
        case .illegalArguments:
            return "잘못된 인수 전달"
        case .emptyResponse:
            return "데이터 없음"
        case .parsing(let cause, let model):
            return "\(model)파싱 오류\n\(cause)"
        case .requestFailed(let statusCode, let message):
            return "[\(statusCode)] \(message ?? "")"
        }
    }
}
