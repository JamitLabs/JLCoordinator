// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public final class TabPresenter: Presenter, TabPresenting {
    public var observers: WeakCache<PresenterObserving> = .init()
    public let tabBarController: UITabBarController

    public init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    public func present(_ viewController: UIViewController, animated: Bool = false) {
        guard tabBarController.viewControllers?.contains(viewController) != true else { return }

        let actualViewControllers = tabBarController.viewControllers ?? []
        tabBarController.setViewControllers(actualViewControllers + [viewController], animated: animated)
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = false) {
        tabBarController.viewControllers?.removeAll { $0 === viewController }
    }
}
