//
//  HttpResponse.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

struct ApiResponse: NetworkResponse {
    var status: Int
    var data: Data?
}
