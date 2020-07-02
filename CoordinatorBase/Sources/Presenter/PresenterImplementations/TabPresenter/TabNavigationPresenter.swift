// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public final class TabNavigationPresenter: NavigationPresenter, TabPresenting {
    public let tabBarController: UITabBarController
    public weak var tabBarItemDelegate: TabBarItemDelegate?

    public init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController

        super.init(navigationController: .init())
    }

    public override func present(_ viewController: UIViewController, animated: Bool = true) {
        guard tabBarController.viewControllers?.contains(navigationController) != true else {
            return super.present(viewController, animated: animated)
        }

        navigationController.pushViewController(viewController, animated: animated)
        let currentViewControllers = tabBarController.viewControllers ?? []
        tabBarController.setViewControllers(currentViewControllers + [navigationController], animated: animated)

        let index = currentViewControllers.count
        tabBarItemDelegate?.tabPresenter(self, presentsViewController: viewController, atTabBarIndex: index)
        navigationController.tabBarItem = viewController.tabBarItem
    }

    public override func dismiss(_ viewController: UIViewController, animated: Bool = true) {
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
