// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

/// This protocol defines all functions and constraints which are necessary for a `Presenter` implementation.
///
/// The `Presenter` implements together with the `PresenterObserving` an Observer pattern to inform
/// all `registered` observers about `present` and `dismiss` events.
public protocol Presenter: AnyObject {
    /// A collection of observers stored as weak references
    var observers: WeakCache<PresenterObserving> { get }

    /// This function implements the presentation logic of the presenter
    ///
    /// - parameters:
    ///     - viewController: The `UIViewController` which should be presented
    ///     - animated: A flag that defines if the presentation should be animated
    func present(_ viewController: UIViewController, animated: Bool)

    /// This function implements the dismiss logic of the presenter
    ///
    /// - parameters:
    ///     - viewController: The `UIViewController` which should be dismissed
    ///     - animated: A flag that defines if the dismissal should be animated
    func dismiss(_ viewController: UIViewController, animated: Bool)

    /// This function implements the dismissal of the root view and its subviews
    ///
    /// - parameters:
    ///     - animated: A flag that defines if the dismissal should be animated
    func dismissRoot(animated: Bool)

    /// This function is implementing the registration logic for the `PresenterObserving`
    ///
    /// - parameters:
    ///     - observer: The `PresenterObserving` which will be registered for presentation notifications
    func register(_ observer: PresenterObserving)

    /// This function is impmlementing the unregsitration logic for the `PresenterObserving
    /// `
    /// - parameters:
    ///     - observer: The subscribed `PresenterObserving` which should be unregistered from presentation notifications
    func unregister(_ observer: PresenterObserving)
}

// MARK: - Base implementation for observer pattern
extension Presenter {
    public func register(_ observer: PresenterObserving) {
        guard !observers.contains(observer) else { return }

        observers.append(observer)
    }

    public func unregister(_ observer: PresenterObserving) {
        observers.remove(observer)
    }

    public func notifyObserverAboutDismiss(of viewController: UIViewController) {
        switch viewController {
        case is UINavigationController:
            guard let navigationController = viewController as? UINavigationController else { return }

            observers.all.forEach { $0.presenter(self, didDismiss: navigationController) }

        default:
            observers.all.forEach { $0.presenter(self, didDismiss: viewController) }
        }
    }

    public func notifyObserverAboutPresentation(of viewController: UIViewController) {
        observers.all.forEach { $0.presenter(self, didPresent: viewController) }
    }

    public func notifyObserverAboutDismissOfAllViewControllers(
        but rootViewController: UIViewController,
        of navigationController: UINavigationController
    ) {
        observers.all.forEach {
            $0.presenter(self, didDismissAllViewControllersTo: rootViewController, of: navigationController)
        }
    }
}
