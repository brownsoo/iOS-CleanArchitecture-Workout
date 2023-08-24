//
//  NetworkClient.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation

class NetworkClient {
    private var decoder: JSONDecoder = {
        let decorder = JSONDecoder()
        let formatter = DateFormatter()
        decorder.dateDecodingStrategy = .custom({ decoder in
            // 2014-04-29T14:18:17-0400
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            if let date = formatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date: \(dateString)")
        })
        return decorder
    }()
}
