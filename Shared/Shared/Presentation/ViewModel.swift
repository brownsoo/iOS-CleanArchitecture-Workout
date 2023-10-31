//
//  ViewModel.swift
//  Shared
//
//  Created by hyonsoo on 11/1/23.
//

import Foundation
import Combine

public protocol ViewModel {
    var errorMessages: AnyPublisher<String, Never> { get }
}

open class BaseViewModel: ViewModel {
    
    public var errorMessages: AnyPublisher<String, Never> {
        _errorMessages.receive(on: RunLoop.main).eraseToAnyPublisher()
    }
    
    public var cancellabels: Set<AnyCancellable> = []
    
    private let _errorMessages = PassthroughSubject<String, Never>()
    
    public init() {}
    
    deinit {
        cancellabels.forEach { work in
            work.cancel()
        }
        cancellabels.removeAll()
    }
    
    open func handleError(_ error: Error) {
        let message: String
        if let e = error as? HumanReadable {
            message = e.humanMessage()
            debugPrint(e)
        } else {
            message = error.localizedDescription
            debugPrint(error)
        }
        _errorMessages.send(message)
    }
}
