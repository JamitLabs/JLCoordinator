// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public protocol TabBarItemDataSource: AnyObject {
    func tabPresenter(_ presenter: TabPresenter, tabBarItemAtIndex index: Int) -> UITabBarItem?
}

public final class TabPresenter: Presenter, TabPresenting {
    public var observers: WeakCache<PresenterObserving> = .init()
    public weak var tabBarItemDataSource: TabBarItemDataSource?
    public let tabBarController: UITabBarController

    public init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    public func present(_ viewController: UIViewController, animated: Bool = false) {
        guard tabBarController.viewControllers?.contains(viewController) != true else { return }

        let currentViewControllers = tabBarController.viewControllers ?? []
        tabBarController.setViewControllers(currentViewControllers + [viewController], animated: animated)
        let index = currentViewControllers.count
        guard let tabBarItem = tabBarItemDataSource?.tabPresenter(self, tabBarItemAtIndex: index) else { return }

        tabBarController.tabBar.items?[index].editWithContentsOfItem(tabBarItem)
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = false) {
        tabBarController.viewControllers?.removeAll { $0 === viewController }
    }
}
