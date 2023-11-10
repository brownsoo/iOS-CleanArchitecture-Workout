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
    /// 캐시 서비스를 씬 단에서 유지.
    /// 캐릭터 저장은 캐릭터 화면들에서만 제공하는 형태.
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
    
    func makeCharactersListViewModel() -> CharactersListViewModel {
        DefaultCharactersListViewModel(characterRepository: makeCharactersRepository())
    }
    
    func makeFavoritesListViewModel() -> CharactersListViewModel {
        DefaultFavoritesListViewModel(characterRepository: makeCharactersRepository())
    }
    
    func makeDetailViewModel(chracter: MarvelCharacter) -> CharacterDetailViewModel {
        DefaultCharacterDetailViewModel(
            character: chracter,
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
    
    func makeCharactersListView() -> UIViewController {
        CharactersListVc.create(viewModel: self.makeCharactersListViewModel())
    }
    
    func makeCharactersDetailView(character: MarvelCharacter) -> UIViewController {
        CharacterDetailVc.create(viewModel: self.makeDetailViewModel(chracter: character))
    }
    
    func makeFavoritesListView() -> UIViewController {
        FavoritesListVc.create(viewModel: self.makeFavoritesListViewModel())
    }
}
