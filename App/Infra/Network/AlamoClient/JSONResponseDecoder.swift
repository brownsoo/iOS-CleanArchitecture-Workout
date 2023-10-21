//
//  JSONResponseDecoder.swift
//  App
//
//  Created by hyonsoo on 10/22/23.
//

import Foundation

class JSONResponseDecoder: ResponseDecoder {
    
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
    
    init(){}
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.parsing(cause: error, model: String(describing: T.self))
        }
    }
}
