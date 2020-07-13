// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public class ModalNavigationPresenter: ModalPresenting, NavigablePresenting {
    public let presentingViewController: UIViewController
    private let adaptivePresentationDelegateWrapper: AdaptivePresentationControllerDelegateWrapper = .init()
    public var navigationController: UINavigationController = .init()
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
        navigationController.delegate = delegateWrapper
        navigationController.presentationController?.delegate = adaptivePresentationDelegateWrapper
        navigationController.addChild(viewController)
        presentModally(navigationController, animated: true)
    }

    public func present(_ viewController: UIViewController, animated: Bool = true) {
        guard navigationController.presentingViewController == nil else {
            return push(viewController, animated: animated)
        }

        startWithUINavigationController(andRootViewController: viewController, animated: animated)
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        if navigationController.viewControllers.first === viewController {
            dismissModally(navigationController, animated: animated)
        } else if navigationController.topViewController === viewController {
            pop(viewController, animated: animated)
        }
    }

    public func dismiss(animated: Bool = true) {
        navigationController.dismiss(animated: animated) { [weak self] in
            guard let topViewController = self?.navigationController.topViewController else { return }

            self?.notifyObserverAboutDismiss(of: topViewController)
        }
    }

    public func dismissRoot(animated: Bool) {
        navigationController?.dismiss(animated: animated) { [weak self] in
            self?.navigationController?.viewControllers.forEach { self?.notifyObserverAboutDismiss(of: $0) }
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
