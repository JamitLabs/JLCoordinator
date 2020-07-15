// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

open class ModalPresenter: ModalPresenting {
    public let observers: WeakCache<PresenterObserving> = .init()

    public let presentingViewController: UIViewController
    private let adaptivePresentationDelegateWrapper: AdaptivePresentationControllerDelegateWrapper = .init()

    public init(presentingViewController: UIViewController) {
        assert(
            presentingViewController.presentedViewController == nil,
            "Trying to initialise ModalPresenter with a `UIViewController` which already is presenting another `UIViewController`. This is not allowed!"
        )

        self.presentingViewController = presentingViewController
        adaptivePresentationDelegateWrapper.delegate = self
    }

    public func present(_ viewController: UIViewController, animated: Bool = true) {
        viewController.presentationController?.delegate = adaptivePresentationDelegateWrapper
        presentModally(viewController, animated: true)
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        dismissModally(viewController, animated: animated)
    }

    public func dismissRoot(animated: Bool) {
        let presentedViewController = presentingViewController.presentedViewController
        // If the presentedViewController is not nil the presentedViewController is dismissed.
        // If the presentedViewController is nil the presentingViewController is dismissed instead.
        // If the dimiss was triggered in a view which is presented by this
        // Presenter then the normal behaviour is that the presentedViewController is dismissed.
        presentingViewController.dismiss(animated: animated) { [weak self] in
            guard let presentedViewController = presentedViewController else { return }

            self?.notifyObserverAboutDismiss(of: presentedViewController)
        }
    }
}

extension ModalPresenter: AdaptivePresentationControllerDelegate {
    func adaptiveDidDismiss(_ viewController: UIViewController) {
        notifyObserverAboutDismiss(of: viewController)
    }
}
