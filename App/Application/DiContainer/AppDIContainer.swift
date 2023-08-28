//
//  AppDIContainer.swift
//  App
//
//  Created by hyonsoo on 2023/08/28.
//

import Foundation

final class AppDIContainer {
    lazy var networkDataService: NetworkDataService = {
       return DefaultNetworkDataService(client: DefaultNetworkClient(),
                                        decoder: JSONResponseDecoder())
    }()
    
    lazy var charactersCache: CharactersStorage = CoreDataCharactersStorage()
    lazy var favoritesCache: FavoritesStorage = CoreDataFavoritesStorage()
}
