//
//  CharactersFlowCoordinator.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

protocol CharactersFlowCoordinatorDependencies {
    func makeCharactersListView(
        actions: CharactersListViewModelActions
    ) -> CharactersListViewController
    
    func makeCharactersDetailView(chracter: MarvelCharacter) -> UIViewController
}

final class CharactersFlowCoordinator {
    private weak var nc: UINavigationController?
    private let dependencies: CharactersFlowCoordinatorDependencies
    
    private weak var listVc: CharactersListViewController?
    
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
        
    }
}
