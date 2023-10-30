//
//  AlamofireNetworkClient.swift
//  MarvelVillain
//
//  Created by hyonsoo han on 2023/08/24.
//

import Foundation
import Alamofire

public class AlamofireNetworkClient: NetworkClient {
    
    static var loggingNetwork = false
    
    let session: Alamofire.Session = {
        let config = URLSessionConfiguration.af.default
        if AlamofireNetworkClient.loggingNetwork {
            let apiLogger = AlarmoLogger()
            return Session(configuration: config, eventMonitors: [apiLogger])
        }
        return Session(configuration: config)
    }()
    
    public init() {}
    
    public func request(_ resource: some NetworkRequest) async throws -> NetworkResponse {
        let request = try resource.toUrlRequest()
        let task = self.session.request(request)
            .validate(statusCode: 200..<299)
            .serializingData()
        let response = await task.response
        
        switch response.result {
            case .success(let data):
                return ApiResponse(status: response.response?.statusCode ?? 0, data: data)
            case .failure(let afError):
                throw self.handleToNetworkError(afError, withData: response.data)
        }
    }
                                        
    private func handleToNetworkError(_ error: AFError, withData data: Data?) -> NetworkError {
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
        return NetworkError.networkError(statusCode: error.responseCode,
                                         cause: error,
                                         data: data)
    }
}
