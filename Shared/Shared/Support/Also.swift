//
//  Also.swift
//  Shared
//
//  Created by hyonsoo on 2023/08/29.
//

import Foundation

public protocol Also {}

public extension Also {
    @discardableResult
    func also(perform thisFn: (Self)->Void) -> Self {
        thisFn(self)
        return self
    }
}

extension NSObject: Also {}
