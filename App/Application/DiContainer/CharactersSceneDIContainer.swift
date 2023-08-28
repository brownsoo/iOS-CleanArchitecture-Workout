//
//  CharactersSceneDIContainer.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import Foundation

final class CharactersSceneDIContainer {
    
    private let networkDataService: NetworkDataService
    lazy var charactersCache: CharactersStorage = CoreDataCharactersStorage()
    lazy var favoritesCache: FavoritesStorage = CoreDataFavoritesStorage()
    
    init(networkDataService: NetworkDataService) {
        self.networkDataService = networkDataService
    }
    
    // MARK: - Repositories
    
    func makeCharactersRepository() -> CharactersRepository {
        DefaultCharactersRepository(dataService: networkDataService,
                                    cache: charactersCache)
    }
    
    func makeFavoritesRepository() -> FavoritesRepository {
        DefaultFavoritesRepository(cache: favoritesCache)
    }
    
    // MARK: - Characters List View
    
    func makeCharactersViewModel(actions: CharactersListViewModelActions) -> CharactersListViewModel {
        
    }
}

extension CharactersSceneDIContainer: CharactersFlowCoordinatorDependencies {
    func makeCharactersListView(actions: CharactersListViewModelActions) -> CharactersListViewController {
        <#code#>
    }
    
    func makeCharactersDetailView(chracter: MarvelCharacter) -> UIViewController {
        <#code#>
    }
}
