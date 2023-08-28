//
//  Response.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

protocol Response {
    var status: Int { get }
    var data: Data? { get }
}
