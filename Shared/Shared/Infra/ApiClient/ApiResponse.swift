//
//  HttpResponse.swift
//  MarvelVillain
//
//  Created by hyonsoo on 2023/08/26.
//

import Foundation

public struct ApiResponse: NetworkResponse {
    public var status: Int
    public var data: Data?
}
