// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

class ModalPresenter: Presenter {
    let observers: WeakCache<PresenterObserving> = .init()

    let presentingViewController: UIViewController
    private let adaptivePresentationDelegateWrapper: AdaptivePresentationControllerDelegateWrapper = .init()

    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        adaptivePresentationDelegateWrapper.delegate = self
    }

    func present(_ viewController: UIViewController, animated: Bool = true) {
        viewController.presentationController?.delegate = adaptivePresentationDelegateWrapper
        presentingViewController.present(viewController, animated: animated) { [weak self] in
            self?.notifyObserverAboutPresentation(of: viewController)
        }
    }

    func dismiss(_ viewController: UIViewController, animated: Bool = true) {
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
