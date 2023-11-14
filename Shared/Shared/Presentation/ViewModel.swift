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
