import UIKit

/// `TabPresenting` defines the base interface for Presenter which work on top of `UITabBarController`
public protocol TabPresenting: Presenter {
    /// The base `UITabBarController`
    var tabBarController: UITabBarController { get }

    /// Initializes a `Presenter` with an `UITabBarController`
    /// - parameter tabBarController: the base `UITabBarController`
    init(tabBarController: UITabBarController)

    /// Presents a `viewController` as a tab ain the `tabBarController`
    /// - parameters:
    ///     - viewController: the `UIViewController` to present on the `tabBarController`
    ///     - animated: A flag that defines if the presentation should be animated
    func presentOnTab(_ viewController: UIViewController, animated: Bool)
}

extension TabPresenting {
    public func presentOnTab(_ viewController: UIViewController, animated: Bool) {
        let currentViewControllers = tabBarController.viewControllers ?? []
        tabBarController.setViewControllers(currentViewControllers + [viewController], animated: animated)
        notifyObserverAboutPresentation(of: viewController)
    }
}
