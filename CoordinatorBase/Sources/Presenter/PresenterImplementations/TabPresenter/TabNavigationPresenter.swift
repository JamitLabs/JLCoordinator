// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

final class TabNavigationPresenter: NavigationPresenter, TabPresenting {
    let tabBarController: UITabBarController

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController

        super.init(navigationController: .init())
    }

    override func present(_ viewController: UIViewController, animated: Bool = true) {
        guard tabBarController.viewControllers?.contains(navigationController) != true else {
            return super.present(viewController, animated: animated)
        }

        navigationController.tabBarItem = viewController.tabBarItem
        navigationController.pushViewController(viewController, animated: animated)
        let actualViewControllers = tabBarController.viewControllers ?? []
        tabBarController.setViewControllers(actualViewControllers + [navigationController], animated: animated)
    }

    override func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        guard
            viewController === navigationController.viewControllers.first,
            tabBarController.viewControllers?.contains(navigationController) == true
        else {
            return super.dismiss(viewController, animated: animated)
        }

        tabBarController.dismiss(animated: animated) { [weak self] in
            self?.notifyObserverAboutDismiss(of: viewController)
        }
    }
}
