// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

/// `PresenterObserving` defines functions which are necessary for an observer to subscribe on a Presenter
public protocol PresenterObserving: AnyObject {
    /// This is called if the `presenter` has been finished the presentation of the `viewController`
    ///
    /// - parameters:
    ///     - presenter: the presenting `Presenter`
    ///     - viewController: the presented `UIViewController`
    func presenter(_ presenter: Presenter, didPresent viewController: UIViewController)

    /// This function is called if the `presenter` did finish the dismiss of an `UIViewController`
    ///
    /// - parameters:
    ///     - presenter: the presenting `Presenter`
    ///     - viewController: the dismissed `UIViewController`
    func presenter(_ presenter: Presenter, didDismiss viewController: UIViewController)

    /// This function is called if the `presenter` didDismiss an `UINavigationController`
    ///
    /// - parameters:
    ///     - presenter: the presenting `Presenter`
    ///     - navigationController: the dismissed `UINavigationController`
    func presenter(_ presenter: Presenter, didDismiss navigationController: UINavigationController)

    /// This function is called if the `presenter` didDismiss all `UIViewController`
    /// but `rootViewController` of a `UINavigationController` stack.
    ///
    /// Use Case: Embedded `UINavigationController` in `UITabBarController`. If the `UITabBarItem` is tapped all
    /// `UIViewController` are popped until `rootViewController` is the top most ViewController.
    /// To handle this case and get informed about this behavior use this function.
    /// This function is also called on a single popped or dismiss and the next presented `UIViewController` is the
    /// `rootViewController`
    ///
    /// - parameters:
    ///     - presenter: the presenting `Presenter`
    ///     - rootViewController: The now presented rootViewController of the `UINavigationController`
    ///     - navigationController: The `UINavigationController` which popped all `UIViewController`
    func presenter(
        _ presenter: Presenter,
        didDismissAllViewControllersTo rootViewController: UIViewController,
        of navigationController: UINavigationController
    )
}
