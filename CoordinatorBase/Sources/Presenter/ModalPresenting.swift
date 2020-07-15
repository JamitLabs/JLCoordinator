// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public protocol ModalPresenting: Presenter {
    /// The `UIViewController` which can present a `viewController` modally
    var presentingViewController: UIViewController { get }

    /// Presents a `UIViewController` modally
    /// - parameters:
    ///     - viewController: The `UIViewController` which is to be presented
    ///     - animated: A flag that defines if the presentation should be animated
    func presentModally(_ viewController: UIViewController, animated: Bool)

    /// Dismisses a `UIViewController` modally
    /// - parameters:
    ///     - viewController: The `UIViewController` which is to be dismissed
    ///     - animated: A flag that defines if the dismissal should be animated
    func dismissModally(_ viewController: UIViewController, animated: Bool)
}

extension ModalPresenting {
    public func presentModally(_ viewController: UIViewController, animated: Bool) {
        presentingViewController.present(viewController, animated: true) { [weak self] in
            self?.notifyObserverAboutPresentation(of: viewController)
        }
    }

    public func dismissModally(_ viewController: UIViewController, animated: Bool) {
        if presentingViewController.presentedViewController === viewController {
            viewController.dismiss(animated: animated) { [weak self] in
                self?.notifyObserverAboutDismiss(of: viewController)
            }
        }
    }
}
