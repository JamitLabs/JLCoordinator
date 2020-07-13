// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import CoordinatorBase
import UIKit

final class TabCoordinator: Coordinator {
    private let tabBarController: UITabBarController = .init()

    override func start() {
        presenter.present(tabBarController, animated: true)

        let tabPresenter = TabPresenter(tabBarController: tabBarController)
        let firstCoordinator = ViewCoordinator(presenter: tabPresenter)
        let secondCoordinator = ViewCoordinator(presenter: tabPresenter)
        let tabNavigationCoordinator = TabNavigationPresenter(tabBarController: tabBarController)
        let thirdCoordinator = ViewCoordinator(presenter: tabNavigationCoordinator)
        add(childCoordinator: firstCoordinator)
        firstCoordinator.start()
        add(childCoordinator: secondCoordinator)
        secondCoordinator.start()
        add(childCoordinator: thirdCoordinator)
        thirdCoordinator.start()
    }
}
