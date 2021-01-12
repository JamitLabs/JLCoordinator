// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import JLCoordinator
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var mainCoordinator: Coordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window: UIWindow = .init(windowScene: windowScene)

        // Option 1: Tabs
        mainCoordinator = TabCoordinator(presenter: InitialPresenter(window: window))
        mainCoordinator?.start()

        // Option 2: Navigation Stack
//        mainCoordinator = ViewCoordinator(presenter: InitialNavigationPresenter(window: window))
//        mainCoordinator?.start()
    }
}
