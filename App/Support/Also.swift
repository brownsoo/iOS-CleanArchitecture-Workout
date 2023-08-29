//
//  Also.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import Foundation

protocol Also {}

extension Also {
    @discardableResult
    func also(perform thisFn: (Self)->Void) -> Self {
        thisFn(self)
        return self
    }
}

extension NSObject: Also {}
