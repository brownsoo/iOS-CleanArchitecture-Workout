//
//  String+Crypto.swift
//  App
//
//  Created by hyonsoo han on 2023/08/30.
// ref: https://stackoverflow.com/a/52120827/2746582

import Foundation
import CryptoKit

public extension Data {
    
    func MD5hashed() -> String? {
        let digest = Insecure.MD5.hash(data: self)
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
