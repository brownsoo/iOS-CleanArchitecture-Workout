//
//  CharactersFlowCoordinator.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit
import Shared
import VillainDetail

protocol CharactersFlowCoordinatorDependencies {
    func makeCharactersListView(actions: CharactersListViewModelActions) -> UIViewController
    func makeCharactersDetailView(character: MarvelCharacter,
                                  actons: CharacterDetailViewModelActions) -> UIViewController
    func makeFavoritesListView(actions: CharactersListViewModelActions) -> UIViewController
}

final class CharactersFlowCoordinator {
    private weak var navigation: UINavigationController?
    private let dependencies: CharactersFlowCoordinatorDependencies
    
    // nc는 CharactersFlowCoordinator가 약참조(weak reference)하고,
    // 주입한 녀석(AppDelegate)이 메인참조를 갖는다.
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
        let actions = CharactersListViewModelActions(
            showCharacterDetails: self.showDetailsView,
            showFavorites: self.showFavoritesView)
        let vc = dependencies.makeFavoritesListView(actions: actions)
        navigation?.pushViewController(vc, animated: true)
    }
}
