// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

class NavigationPresenter: Presenter {
    let observers: WeakCache<PresenterObserving> = .init()

    let navigationController: UINavigationController
    let delegateWrapper: NavigationControllerDelegateWrapper = .init()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        delegateWrapper.delegate = self
        navigationController.delegate = delegateWrapper
    }

    func present(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        guard navigationController.topViewController === viewController else { return }

        navigationController.popViewController(animated: animated)
    }
}

extension NavigationPresenter: NavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didPop viewController: UIViewController) {
        notifyObserverAboutDismiss(of: viewController)
    }

    func navigationController(_ navigationController: UINavigationController, didPush viewController: UIViewController) {
        notifyObserverAboutPresentation(of: viewController)
    }
}
