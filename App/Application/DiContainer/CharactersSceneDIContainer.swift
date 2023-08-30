//
//  CharactersSceneDIContainer.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

final class CharactersSceneDIContainer {
    
    private let networkDataService: NetworkDataService
    private lazy var charactersCache: CharactersStorage = CoreDataCharactersStorage()
    
    init(networkDataService: NetworkDataService) {
        self.networkDataService = networkDataService
    }
    
    // MARK: - Repositories
    
    func makeCharactersRepository() -> CharactersRepository {
        DefaultCharactersRepository(dataService: networkDataService,
                                    cache: charactersCache)
    }
    
    // MARK: - ViewModels
    
    func makeCharactersViewModel(actions: CharactersListViewModelActions) -> CharactersListViewModel {
        DefaultCharactersListViewModel(actions: actions,
                                       characterRepository: makeCharactersRepository())
    }
}

extension CharactersSceneDIContainer {
    func makeCharactersFlowCoordinator(nc: UINavigationController) -> CharactersFlowCoordinator {
        CharactersFlowCoordinator(nc: nc, dependencies: self)
    }
}

extension CharactersSceneDIContainer: CharactersFlowCoordinatorDependencies {
    
    func makeCharactersListView(actions: CharactersListViewModelActions) -> CharactersListVc {
        CharactersListVc.create(viewModel: self.makeCharactersViewModel(actions: actions))
    }
    
    func makeCharactersDetailView(chracter: MarvelCharacter) -> CharacterDetailVc {
        CharacterDetailVc()
    }
    
    func makeFavoritesListView(actions: CharactersListViewModelActions) -> FavoritesListVc {
        FavoritesListVc.create(viewModel: self.makeCharactersViewModel(actions: actions))
    }
}
