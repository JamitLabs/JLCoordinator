// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public class NavigationPresenter: NavigablePresenting {
    public let observers: WeakCache<PresenterObserving> = .init()
    public let navigationController: UINavigationController
    private let delegateWrapper: NavigationControllerDelegateWrapper = .init()

    public init(navigationController: UINavigationController) {
        assert(
            navigationController.viewControllers.isEmpty,
            "Trying to intialise NavigationPresenter with an non empty UINavigationController. This is not allowed!"
        )

        self.navigationController = navigationController
        delegateWrapper.delegate = self
        navigationController.delegate = delegateWrapper
    }

    public func present(_ viewController: UIViewController, animated: Bool = true) {
        push(viewController, animated: animated)
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        pop(viewController, animated: animated)
    }

    public func dismissRoot(animated: Bool) {
        navigationController.dismiss(animated: animated) { [weak self] in
            self?.navigationController.viewControllers.forEach { self?.notifyObserverAboutDismiss(of: $0) }
        }
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
