//
//  NetworkClient.swift
//  App
//
//  Created by hyonsoo on 10/22/23.
//

import Foundation

protocol NetworkClient {
    func request(_ resource: some NetworkRequest) async throws -> NetworkResponse
}
