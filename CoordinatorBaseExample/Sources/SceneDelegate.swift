// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

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
    }
}
