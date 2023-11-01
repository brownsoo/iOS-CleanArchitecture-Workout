//
//  CharactersSceneProvider.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit
import Shared
import VillainDetail

final class CharactersSceneProvider {
    
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

extension CharactersSceneProvider {
    func makeCharactersFlowCoordinator(nc: UINavigationController) -> CharactersFlowCoordinator {
        // CharactersFlowCoordinator 가 CharactersSceneProvider를 참조로 가져간다.
        // nc 는 약참조로.
        CharactersFlowCoordinator(nc: nc, dependencies: self)
    }
}

extension CharactersSceneProvider: CharactersFlowCoordinatorDependencies {
    
    func makeCharactersListView(actions: CharactersListViewModelActions) -> UIViewController {
        CharactersListVc.create(viewModel: self.makeCharactersListViewModel(actions: actions))
    }
    
    func makeCharactersDetailView(character: MarvelCharacter,
                                  actons: CharacterDetailViewModelActions) -> UIViewController {
        CharacterDetailVc.create(viewModel: self.makeDetailViewModel(chracter: character, actions: actons))
    }
    
    func makeFavoritesListView(actions: CharactersListViewModelActions) -> UIViewController {
        FavoritesListVc.create(viewModel: self.makeFavoritesListViewModel(actions: actions))
    }
}
