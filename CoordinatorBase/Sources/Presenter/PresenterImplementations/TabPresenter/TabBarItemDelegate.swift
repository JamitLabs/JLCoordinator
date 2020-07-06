// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public protocol TabBarItemDelegate: AnyObject {
    /// This method is called right before the view controller is presented in a `UITabBarController` by a presenter.
    /// The delegate should configure the view controller with a `UITabBarItem` if one is needed.
    ///
    /// - parameters:
    ///     - presenter: The object that is presenting the view controller on a `UITabBarController`
    ///     - viewController: The view controller that is presented by the `presenter`
    ///     - index: The index of the `viewControllers` array of the `UITabBarController` in which the view controller is presented
    func tabPresenter(_ presenter: TabPresenting, presentsViewController viewController: UIViewController, atTabBarIndex index: Int)
}
