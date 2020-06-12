// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

final class TabPresenter: Presenter, TabPresenting {
    var observers: WeakCache<PresenterObserving> = .init()
    let tabBarController: UITabBarController

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    func present(_ viewController: UIViewController, animated: Bool = false) {
        guard tabBarController.viewControllers?.contains(viewController) != true else { return }

        let actualViewControllers = tabBarController.viewControllers ?? []
        tabBarController.setViewControllers(actualViewControllers + [viewController], animated: animated)
    }

    func dismiss(_ viewController: UIViewController, animated: Bool = false) {
        tabBarController.viewControllers?.removeAll { $0 === viewController }
    }
}
