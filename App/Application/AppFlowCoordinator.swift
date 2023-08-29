//
//  AppFlowCoordinator.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

final class AppFlowCoordinator {
    var navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        let sceneDIContainer = diContainer.makeCharactersSceneDIContainer()
        let flow = sceneDIContainer.makeCharactersFlowCoordinator(nc: navigationController)
        flow.start()
    }
}
