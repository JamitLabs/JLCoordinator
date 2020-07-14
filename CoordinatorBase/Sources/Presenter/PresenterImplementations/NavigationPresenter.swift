// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public class NavigationPresenter: NavigablePresenting {
    public let observers: WeakCache<PresenterObserving> = .init()
    public let navigationController: UINavigationController
    private let delegateWrapper: NavigationControllerDelegateWrapper = .init()

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        delegateWrapper.delegate = self
        navigationController.delegate = delegateWrapper
    }

    public func present(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        guard navigationController.topViewController === viewController else { return }

        navigationController.popViewController(animated: animated)
    }
}

extension NavigationPresenter: NavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        didPop viewController: UIViewController
    ) {
        notifyObserverAboutDismiss(of: viewController)
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        didPush viewController: UIViewController
    ) {
        notifyObserverAboutPresentation(of: viewController)
    }
}
