//
//  AppError.swift
//  App
//
//  Created by hyonsoo on 10/21/23.
//

import Foundation

enum AppError: Error {
    case runtime(cause: Error, message: String?)
    case illegalArguments
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
        }
    }
}
