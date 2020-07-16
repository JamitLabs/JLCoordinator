// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public class ModalNavigationPresenter: ModalPresenting, NavigablePresenting {
    public let presentingViewController: UIViewController
    private let adaptivePresentationDelegateWrapper: AdaptivePresentationControllerDelegateWrapper = .init()
    public var navigationController: UINavigationController?
    let delegateWrapper: NavigationControllerDelegateWrapper = .init()

    public let observers: WeakCache<PresenterObserving> = .init()

    public init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        adaptivePresentationDelegateWrapper.delegate = self
        delegateWrapper.delegate = self
    }

    private func startWithUINavigationController(
        andRootViewController viewController: UIViewController,
        animated: Bool
    ) {
        navigationController = .init(rootViewController: viewController)
        navigationController?.delegate = delegateWrapper
        navigationController?.presentationController?.delegate = adaptivePresentationDelegateWrapper
        presentModally(navigationController!, animated: true) { [weak self] in
            self?.notifyObserverAboutPresentation(of: viewController)
        }
    }

    public func present(_ viewController: UIViewController, animated: Bool = true) {
        guard navigationController?.presentingViewController == nil else {
            return push(viewController, animated: animated)
        }

        startWithUINavigationController(andRootViewController: viewController, animated: animated)
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        guard let navigationController = navigationController else { return }

        if navigationController.viewControllers.first === viewController {
            dismissModally(navigationController, animated: animated) { [weak self] in
                self?.notifyObserverAboutPresentation(of: viewController)
            }
        } else if navigationController.topViewController === viewController {
            pop(viewController, animated: animated)
        }
    }

    public func dismiss(animated: Bool = true) {
        guard let navigationController = navigationController else { return }

        navigationController.dismiss(animated: animated) { [weak self] in
            guard let topViewController = self?.navigationController?.topViewController else { return }

            self?.notifyObserverAboutDismiss(of: topViewController)
        }
    }

    public func dismissRoot(animated: Bool) {
        navigationController?.dismiss(animated: animated) { [weak self] in
            guard let navigationController = self?.navigationController else { return }

            navigationController.viewControllers.forEach { self?.notifyObserverAboutDismiss(of: $0) }
            self?.notifyObserverAboutDismiss(of: navigationController)
        }
    }
}

extension ModalNavigationPresenter: AdaptivePresentationControllerDelegate {
    func adaptiveDidDismiss(_ viewController: UIViewController) {
        notifyObserverAboutDismiss(of: viewController)
    }
}

extension ModalNavigationPresenter: NavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didPop viewController: UIViewController) {
        notifyObserverAboutDismiss(of: viewController)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        didPush viewController: UIViewController
    ) {
        notifyObserverAboutPresentation(of: viewController)
    }
}
