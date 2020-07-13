// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

/// `TabPresenting` defines the base interface for Presenter which work on top of `UITabBarController`
public protocol TabPresenting: Presenter {
    /// The base `UITabBarController`
    var tabBarController: UITabBarController { get }

    /// Initializes a `Presenter` with an `UITabBarController`
    /// - parameter tabBarController: the base `UITabBarController`
    init(tabBarController: UITabBarController)
}
