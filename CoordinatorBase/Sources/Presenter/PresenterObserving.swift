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
}
