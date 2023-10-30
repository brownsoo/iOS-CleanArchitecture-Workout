//
//  AppDIContainer.swift
//  App
//
//  Created by hyonsoo on 2023/08/28.
//

import Foundation
import Shared

final class AppDIContainer {
    
    lazy var networkDataService: NetworkDataService = {
       DefaultNetworkDataService(client: AlamofireNetworkClient(),
                                 decoder: JSONResponseDecoder())
    }()
    
    func makeCharactersSceneDIContainer() -> CharactersSceneDIContainer {
        CharactersSceneDIContainer(networkDataService: networkDataService)
    }
}
