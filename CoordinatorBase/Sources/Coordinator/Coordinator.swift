// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

/// The base class of all `Coordinators`. `Coordinator` handles the screen flows and navigation. Additionally it
/// connects the UI to the the models for example our interactors.
/// For usage subclass it and implement at least the `start` function.
open class Coordinator: PresenterObserving {
    /// All added children coordinators
    public var childCoordinators: [Coordinator] = []
    /// The parentCoordinator of this Coordinator
    public weak var parentCoordinator: Coordinator?

    /// The presenter of this Coordinator it is notifing this Coordinator about dismissal and presentation of
    /// `UIViewController` and its subclasses.
    open var presenter: Presenter {
        didSet {
            oldValue.unregister(self)
            presenter.register(self)
        }
    }

    /// Intializes a new Coordinator with the given presenter
    /// - parameters:
    ///     - presenter: The `Presenter of this Coordinator. It should be used to present or dismiss `UIViewController`,
    /// `UITabBarController` or `UINavigationController`
    public init(presenter: Presenter) {
        self.presenter = presenter
        self.presenter.register(self)
    }

    /// The function starts the Coordinator and should be overwritten for custom implementation. A common implementation
    /// is to assign delegates of viewControllers and presenting them by the stored `presenter`.
    ///
    /// Example:
    ///
    /// ```swift
    /// override public func start() {
    ///     super.start()
    ///
    ///     viewController.delegate = self
    ///     presenter.present(viewController, animated: true)
    /// }
    /// ```
    open func start() {
        // Should be overriden in subclass
    }

    /// Stops this coordinator and all of its children which are contained in childCoordinators array. After stopping
    /// all children the `parentCoordinator` is informed about the stop of this coordinator. Last this coordinator is
    /// removed from the parents `childCoordinator` array.
    open func stop() {
        childCoordinators.forEach { $0.stop() }
        parentCoordinator?.didStop(child: self)
        removeFromParentCoordinator()
    }

    /// Adds another `Coordinator` as child. Should be called before the child has been started.
    ///
    /// - parameters:
    ///   - child: The coordinator which is added as child. After adding the childs parentCoordinator property is set
    ///   to this coordinator
    open func add(childCoordinator child: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === child }) else {
            return NSLog(
                "⚠️ Coordinator \(String(describing: self)) - \(#function): Coordinator is already added as child"
            )
        }

        child.parentCoordinator = self
        childCoordinators.append(child)
    }

    /// Removes this coordinator from its parent
    /// After the removal the `parent` is informed and the `parent` property is set to nil.
    open func removeFromParentCoordinator() {
        parentCoordinator?.childCoordinators.removeAll { $0 === self }
        parentCoordinator?.didRemove(child: self)
        parentCoordinator = nil
    }

    /// This function is called by child coordinators after they removed themself from its parent
    /// - parameters:
    ///    - child: The removed child coordinator.
    open func didRemove(child: Coordinator) {
        // Called if child has been removed from `childCoordinators` list
    }

    /// This function is called by child coordinators after they stopped
    /// - parameters:
    ///    - child: The stopped child coordinator.
    open func didStop(child: Coordinator) {
        // Called if child has been stopped
    }

    open func presenter(_ presenter: Presenter, didDismiss viewController: UIViewController) {
        // Override in subclass
    }

    open func presenter(_ presenter: Presenter, didPresent viewController: UIViewController) {
        // Override in sublcass
    }

    open func presenter(_ presenter: Presenter, didDismiss navigationController: UINavigationController) {
        // Override in sublclass
    }

    open func presenter(
        _ presenter: Presenter,
        didDismissAllViewControllersTo rootViewController: UIViewController,
        of navigationController: UINavigationController
    ) {
        // Override in subclass
    }
}
