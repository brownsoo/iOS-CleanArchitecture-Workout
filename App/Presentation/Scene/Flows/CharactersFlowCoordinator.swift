//
//  CharactersFlowCoordinator.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

protocol CharactersFlowCoordinatorDependencies {
    func makeCharactersListView(actions: CharactersListViewModelActions) -> CharactersListVc
    func makeCharactersDetailView(character: MarvelCharacter,
                                  actons: CharacterDetailViewModelActions) -> CharacterDetailVc
    func makeFavoritesListView(actions: CharactersListViewModelActions) -> FavoritesListVc
}

final class CharactersFlowCoordinator {
    private weak var navigation: UINavigationController?
    private let dependencies: CharactersFlowCoordinatorDependencies
    
    init(nc: UINavigationController?,
         dependencies: CharactersFlowCoordinatorDependencies) {
        self.navigation = nc
        self.dependencies = dependencies
    }
    
    func start() {
        foot()
        let actions = CharactersListViewModelActions(
            showCharacterDetails: self.showDetailsView,
            showFavorites: self.showFavoritesView)
        let vc = dependencies.makeCharactersListView(actions: actions)
        navigation?.pushViewController(vc, animated: false)
    }
    
    private func showDetailsView(character: MarvelCharacter) {
        let actions = CharacterDetailViewModelActions()
        let vc = dependencies.makeCharactersDetailView(character: character, actons: actions)
        navigation?.pushViewController(vc, animated: true)
    }
    
    private func showFavoritesView() {
        let actions = CharactersListViewModelActions(showCharacterDetails: self.showDetailsView,
                                                     showFavorites: nil)
        let vc = dependencies.makeFavoritesListView(actions: actions)
        navigation?.pushViewController(vc, animated: true)
    }
}
