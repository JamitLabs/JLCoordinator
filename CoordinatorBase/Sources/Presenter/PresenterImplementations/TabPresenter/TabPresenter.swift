// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public final class TabPresenter: Presenter, TabPresenting {
    public var observers: WeakCache<PresenterObserving> = .init()
    public weak var tabBarItemDelegate: TabBarItemDelegate?
    public let tabBarController: UITabBarController

    public init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    public func present(_ viewController: UIViewController, animated: Bool = false) {
        guard tabBarController.viewControllers?.contains(viewController) != true else { return }

        let currentViewControllers = tabBarController.viewControllers ?? []
        tabBarController.setViewControllers(currentViewControllers + [viewController], animated: animated)
        let index = currentViewControllers.count
        tabBarItemDelegate?.tabPresenter(self, presentsViewController: viewController, atTabBarIndex: index)
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = false) {
        guard tabBarController.viewControllers?.contains(viewController) == true else { return }

        guard tabBarController.viewControllers!.count > 1 else {
            tabBarController.dismiss(animated: true) { [weak self] in
                self?.notifyObserverAboutDismiss(of: viewController)
            }

            return
        }

        tabBarController.viewControllers?.removeAll { $0 === viewController }
    }
}
