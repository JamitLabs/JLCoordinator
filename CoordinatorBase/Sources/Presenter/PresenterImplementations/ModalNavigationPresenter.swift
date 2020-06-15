// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public class ModalNavigationPresenter: Presenter {
    let presentingViewController: UIViewController
    private let adaptivePresentationDelegateWrapper: AdaptivePresentationControllerDelegateWrapper = .init()
    var navigationController: UINavigationController?
    let delegateWrapper: NavigationControllerDelegateWrapper = .init()

    public let observers: WeakCache<PresenterObserving> = .init()

    public init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        adaptivePresentationDelegateWrapper.delegate = self
        delegateWrapper.delegate = self
    }

    private func startWithUINavigationController(andRootViewController viewController: UIViewController, animated: Bool) {
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController?.delegate = delegateWrapper
        navigationController?.presentationController?.delegate = adaptivePresentationDelegateWrapper
        presentingViewController.present(navigationController!, animated: true) { [weak self] in
            self?.notifyObserverAboutPresentation(of: viewController)
        }
    }

    public func present(_ viewController: UIViewController, animated: Bool = true) {
        if let navigationController = navigationController {
            navigationController.pushViewController(viewController, animated: animated)
        } else {
            startWithUINavigationController(andRootViewController: viewController, animated: animated)
        }
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        if navigationController?.viewControllers.first === viewController {
            navigationController?.dismiss(animated: animated) { [weak self] in
                self?.notifyObserverAboutDismiss(of: viewController)
            }
        } else if navigationController?.topViewController === viewController {
            navigationController?.popViewController(animated: animated)
        }
    }

    public func dismiss(animated: Bool = true) {
        navigationController?.dismiss(animated: animated) { [weak self] in
            guard let topViewController = self?.navigationController?.topViewController else { return }

            self?.notifyObserverAboutDismiss(of: topViewController)
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
