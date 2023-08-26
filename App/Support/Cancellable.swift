//
//  Cancellable.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

protocol Cancellable {
    func cancel()
}

extension Task: Cancellable {}
