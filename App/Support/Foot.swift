//
//  Foot.swift
//  App
//
//  Created by hyonsoo han on 2023/08/30.
//

import Foundation

func foot(_ msg: String? = nil, filename: String = #file, funcName: String = #function) {
    print("foot** \(filename.components(separatedBy: "/").last ?? filename) \t\(funcName) \(msg ?? "")")
}

