//
//  AppFlowCoordinator.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit
import Shared

final class AppFlowCoordinator {
    private var navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
        setupRouting()
    }
    
    func start() {
        let sceneProvider = diContainer.makeCharactersSceneProvider()
        let vc = sceneProvider.makeCharactersListView()
        navigationController.pushViewController(vc, animated: false)
    }
}

extension AppFlowCoordinator {
    private func setupRouting() {
        
        Router.routeResolver = { destination, transition, animating in
            let vc: UIViewController?
            switch destination {
            case .characterDetail(let character):
                let sceneProvider = self.diContainer.makeCharactersSceneProvider()
                vc = sceneProvider.makeCharactersDetailView(character: character)
                break
            case .favorites:
                let sceneProvider = self.diContainer.makeCharactersSceneProvider()
                vc = sceneProvider.makeFavoritesListView()
                break
            }
            guard vc != nil else {
                return
            }
            
            switch transition {
            case .push:
                self.navigationController.pushViewController(vc!, animated: animating)
            case .cover:
                self.navigationController.present(vc!, animated: animating)
            }
        }   
    }
}
