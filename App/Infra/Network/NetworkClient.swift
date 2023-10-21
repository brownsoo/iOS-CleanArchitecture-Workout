//
//  NetworkClient.swift
//  App
//
//  Created by hyonsoo on 10/22/23.
//

import Foundation

protocol NetworkClient {
    func request(_ resource: NetworkResource) async throws -> NetworkResponse
}
