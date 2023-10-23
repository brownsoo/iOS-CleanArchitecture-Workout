//
//  AlamofireNetworkClient.swift
//  KisTest
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation
import Alamofire

class AlamofireNetworkClient: NetworkClient {
    
    let session: Alamofire.Session = {
        let config = URLSessionConfiguration.af.default
        let apiLogger = AlarmoLogger()
#if DEBUG
        return Session(configuration: config, eventMonitors: [apiLogger])
#else
        return Session(configuration: config)
#endif
    }()
    
    func request(_ resource: some NetworkRequest) async throws -> NetworkResponse {
        let request = try resource.toUrlRequest()
        let task = self.session.request(request)
            .validate(statusCode: 200..<299)
            .serializingData()
        let response = await task.response
        
        switch response.result {
            case .success(let data):
                return ApiResponse(status: response.response?.statusCode ?? 0, data: data)
            case .failure(let afError):
                throw self.handleError(afError, withData: response.data)
        }
    }
                                        
    private func handleError(_ error: AFError, withData data: Data?) -> NetworkError {
        if let data = data,
           let res = try? JSONDecoder().decode(ResMarvelError.self, from: data) {
            return NetworkError.requestFailed(statusCode: res.code, message: res.status)
        }
        if error.responseCode == 304 {
            return NetworkError.contentNotChanged
        }
        if let nsError = error.underlyingError as? NSError {
            switch(nsError.code) {
                case NSURLErrorTimedOut,
                    NSURLErrorNotConnectedToInternet,
                    NSURLErrorInternationalRoamingOff,
                    NSURLErrorDataNotAllowed,
                    NSURLErrorCannotFindHost,
                    NSURLErrorCannotConnectToHost,
                    NSURLErrorNetworkConnectionLost:
                    return NetworkError.networkDisconnected
                default:
                    break
                    
            }
        }
        return NetworkError.networkError(cause: error)
    }
}
