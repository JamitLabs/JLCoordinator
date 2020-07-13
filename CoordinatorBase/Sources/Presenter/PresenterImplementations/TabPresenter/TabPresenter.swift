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

        let currentViewControllers = tabBarController.viewControllers ?? []
        tabBarController.setViewControllers(currentViewControllers + [viewController], animated: animated)
        notifyObserverAboutPresentation(of: viewController)
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = false) {
       NSLog("⚠️ Presenter \(String(describing: self)) - \(#function): TabPresenter doesn't dismiss its root views")
    }
}
