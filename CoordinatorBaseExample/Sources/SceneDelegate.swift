//
//  SceneDelegate.swift
//  CoordinatorBaseExample
//
//  Created by Jens Krug on 12.06.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import CoordinatorBase
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var tabCoordinator: TabCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window: UIWindow = .init(windowScene: windowScene)
        tabCoordinator = .init(presenter: InitialPresenter(window: window))
        tabCoordinator?.start()
        tabCoordinator?.addTab { tabBarController -> Coordinator in
            return ViewCoordinator(presenter: TabPresenter(tabBarController: tabBarController))
        }
    }
}
