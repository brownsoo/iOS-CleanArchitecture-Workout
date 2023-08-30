//
//  AppFlowCoordinator.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import UIKit

final class AppFlowCoordinator {
    private(set) var navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        let sceneContainer = diContainer.makeCharactersSceneDIContainer()
        let flow = sceneContainer.makeCharactersFlowCoordinator(nc: navigationController)
        flow.start()
    }
}
