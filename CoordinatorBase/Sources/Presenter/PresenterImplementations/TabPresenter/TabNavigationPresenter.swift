// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public final class TabNavigationPresenter: NavigationPresenter, TabPresenting {
    public let tabBarController: UITabBarController

    public init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController

        super.init(navigationController: .init())
    }

    override public func present(_ viewController: UIViewController, animated: Bool = true) {
        guard tabBarController.viewControllers?.contains(navigationController) != true else {
            return super.present(viewController, animated: animated)
        }

        navigationController.pushViewController(viewController, animated: animated)
        navigationController.tabBarItem = viewController.tabBarItem
        let currentViewControllers = tabBarController.viewControllers ?? []
        tabBarController.setViewControllers(currentViewControllers + [navigationController], animated: animated)
        notifyObserverAboutPresentation(of: viewController)
    }

    override public func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        guard
            viewController === navigationController.viewControllers.first,
            tabBarController.viewControllers?.contains(navigationController) == true
        else {
            return super.dismiss(viewController, animated: animated)
        }
    }
}
