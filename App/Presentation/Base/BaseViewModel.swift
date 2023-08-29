//
//  BaseViewModel.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import Foundation
import Combine

class BaseViewModel {
    
    var cancellabels: Set<AnyCancellable> = []
    var errorMessages: AnyPublisher<String, Never> {
        _errorMessages.eraseToAnyPublisher()
    }
    
    private let _errorMessages = PassthroughSubject<String, Never>()
    
    deinit {
        cancellabels.forEach { work in
            work.cancel()
        }
        cancellabels.removeAll()
    }
    
    func handleError(_ error: Error) {
        let message: String
        if let e = error as? AppError {
            message = e.humanMessage()
            debugPrint(e)
        } else {
            message = error.localizedDescription
            debugPrint(error)
        }
        _errorMessages.send(message)
    }
}
