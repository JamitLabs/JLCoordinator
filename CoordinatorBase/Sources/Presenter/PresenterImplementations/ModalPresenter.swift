// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

open class ModalPresenter: ModalPresenting {
    public let observers: WeakCache<PresenterObserving> = .init()

    public let presentingViewController: UIViewController
    private let adaptivePresentationDelegateWrapper: AdaptivePresentationControllerDelegateWrapper = .init()

    public init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        adaptivePresentationDelegateWrapper.delegate = self
    }

    public func present(_ viewController: UIViewController, animated: Bool = true) {
        viewController.presentationController?.delegate = adaptivePresentationDelegateWrapper
        presentingViewController.present(viewController, animated: animated) { [weak self] in
            self?.notifyObserverAboutPresentation(of: viewController)
        }
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        if presentingViewController.presentedViewController === viewController {
            viewController.dismiss(animated: animated) { [weak self] in
                self?.notifyObserverAboutDismiss(of: viewController)
            }
        }
    }
}

extension ModalPresenter: AdaptivePresentationControllerDelegate {
    func adaptiveDidDismiss(_ viewController: UIViewController) {
        notifyObserverAboutDismiss(of: viewController)
    }
}
