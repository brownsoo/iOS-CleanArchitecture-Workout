//
//  CharactersSceneDIContainer.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

final class CharactersSceneDIContainer {
    
    private let networkDataService: NetworkDataService
    lazy var charactersCache: CharactersStorage = CoreDataCharactersStorage()
    
    init(networkDataService: NetworkDataService) {
        self.networkDataService = networkDataService
    }
    
    // MARK: - Repositories
    
    func makeCharactersRepository() -> CharactersRepository {
        DefaultCharactersRepository(dataService: networkDataService,
                                    cache: charactersCache)
    }
    
    // MARK: - Characters List View
    
    func makeCharactersViewModel(actions: CharactersListViewModelActions) -> CharactersListViewModel {
        DefaultCharactersListViewModel(actions: actions,
                                       characterRepository: makeCharactersRepository())
    }
}

extension CharactersSceneDIContainer: CharactersFlowCoordinatorDependencies {
    func makeCharactersListView(actions: CharactersListViewModelActions) -> CharactersListViewController {
        return CharactersListViewController()
    }
    
    func makeCharactersDetailView(chracter: MarvelCharacter) -> UIViewController {
        return UIViewController()
    }
}
