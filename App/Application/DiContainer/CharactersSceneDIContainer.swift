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
    
    func makeCharactersListViewModel(actions: CharactersListViewModelActions) -> CharactersListViewModel {
        DefaultCharactersListViewModel(actions: actions,
                                       characterRepository: makeCharactersRepository())
    }
    
    func makeFavoritesListViewModel(actions: CharactersListViewModelActions) -> CharactersListViewModel {
        DefaultFavoritesListViewModel(actions: actions,
                                      characterRepository: makeCharactersRepository())
    }
    
    func makeDetailViewModel(chracter: MarvelCharacter,
                             actions: CharacterDetailViewModelActions) -> CharacterDetailViewModel {
        DefaultCharacterDetailViewModel(
            character: chracter,
            actions: actions,
            repository: makeCharactersRepository()
        )
    }
}

extension CharactersSceneDIContainer {
    func makeCharactersFlowCoordinator(nc: UINavigationController) -> CharactersFlowCoordinator {
        CharactersFlowCoordinator(nc: nc, dependencies: self)
    }
}

extension CharactersSceneDIContainer: CharactersFlowCoordinatorDependencies {
    
    func makeCharactersListView(actions: CharactersListViewModelActions) -> CharactersListVc {
        CharactersListVc.create(viewModel: self.makeCharactersListViewModel(actions: actions))
    }
    
    func makeCharactersDetailView(character: MarvelCharacter,
                                  actons: CharacterDetailViewModelActions) -> CharacterDetailVc {
        CharacterDetailVc.create(viewModel: self.makeDetailViewModel(chracter: character, actions: actons))
    }
    
    func makeFavoritesListView(actions: CharactersListViewModelActions) -> FavoritesListVc {
        FavoritesListVc.create(viewModel: self.makeFavoritesListViewModel(actions: actions))
    }
}
