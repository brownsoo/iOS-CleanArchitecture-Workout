//
//  CharactersFlowCoordinator.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

protocol CharactersFlowCoordinatorDependencies {
    func makeCharactersListView(actions: CharactersListViewModelActions) -> CharactersListVc
    func makeCharactersDetailView(chracter: MarvelCharacter) -> CharacterDetailVc
    func makeFavoritesListView(actions: CharactersListViewModelActions) -> FavoritesListVc
}

final class CharactersFlowCoordinator {
    private weak var nc: UINavigationController?
    private let dependencies: CharactersFlowCoordinatorDependencies
    // FIXME: 왜 갖고 있지?
    private weak var listVc: CharactersListVc?
    
    init(nc: UINavigationController? = nil,
         dependencies: CharactersFlowCoordinatorDependencies) {
        self.nc = nc
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = CharactersListViewModelActions(showCharacterDetails: self.showDetailsView,
                                                     showFavorites: self.showFavoritesView)
        let vc = dependencies.makeCharactersListView(actions: actions)
        nc?.pushViewController(vc, animated: true)
        listVc = vc
    }
    
    private func showDetailsView(character: MarvelCharacter) {
        let vc = dependencies.makeCharactersDetailView(chracter: character)
        nc?.pushViewController(vc, animated: true)
    }
    
    private func showFavoritesView() {
        let actions = CharactersListViewModelActions(showCharacterDetails: self.showDetailsView,
                                                     showFavorites: nil)
        let vc = dependencies.makeFavoritesListView(actions: actions)
        nc?.pushViewController(vc, animated: true)
    }
}
