import UIKit

public protocol ModalPresenting: Presenter {
    /// The `UIViewController` which can present a `viewController` modally
    var presentingViewController: UIViewController { get }

    /// Presents a `UIViewController` modally
    /// - parameters:
    ///     - viewController: The `UIViewController` which is to be presented
    ///     - animated: A flag that defines if the presentation should be animated
    ///     - completion: optional closure which is called after the presentation has been finished
    func presentModally(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)

    /// Dismisses a `UIViewController` modally
    /// - parameters:
    ///     - viewController: The `UIViewController` which is to be dismissed
    ///     - animated: A flag that defines if the dismissal should be animated
    ///     - completion: optional closure which is called after the dismissal has been finished
    func dismissModally(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
}

extension ModalPresenting {
    public func presentModally(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        presentingViewController.present(viewController, animated: animated) { [weak self] in
            self?.notifyObserverAboutPresentation(of: viewController)
            completion?()
        }
    }

    public func dismissModally(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        if presentingViewController.presentedViewController === viewController {
            viewController.dismiss(animated: animated) { [weak self] in
                self?.notifyObserverAboutDismiss(of: viewController)
                completion?()
            }
        }
    }
}
