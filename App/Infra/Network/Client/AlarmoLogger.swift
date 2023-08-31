//
//  AlarmoLogger.swift
//  KisTest
//
//  Created by hyonsoo on 2023/08/25.
//

import Foundation
import Alamofire

class AlarmoLogger: EventMonitor {
    let queue = DispatchQueue(label: "AlarmoLogger")
    
    func requestDidFinish(_ request: Request) {
        print("===== NETWORK Reqeust ====> ")
        // print(request.description)
        
        print(
            "\(request.request?.httpMethod ?? "") :: " + (request.request?.url?.absoluteString ?? "")  + "\n"
            + "Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])" + "\n"
        )
        //print("Authorization: " + (request.request?.headers["Authorization"] ?? ""))
        print("Body: " + (request.request?.httpBody?.toPrettyPrintedString ?? ""))
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: Alamofire.DataResponse<Value, AFError>) {
        print(
            "<=====\(request.request?.httpMethod ?? "") :: " + (request.request?.url?.absoluteString ?? "") + "\n"
            //+ "Result: " + "\(response.result)" + "\n"
            + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
            + "Data: \(response.data?.toPrettyPrintedString ?? "")"
        )
    }
}

fileprivate extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
