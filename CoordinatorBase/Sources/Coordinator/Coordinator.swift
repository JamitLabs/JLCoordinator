// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

open class Coordinator: PresenterObserving {
    public var childCoordinators: [Coordinator] = []
    public weak var parentCoordinator: Coordinator?
    public weak var addTabDelegate: AddTabDelegate?
    public var presenter: Presenter {
        didSet {
            oldValue.unregister(self)
            presenter.register(self)
        }
    }

    public init(presenter: Presenter) {
        self.presenter = presenter
        self.presenter.register(self)
    }

    open func start() {
        // Should be overriden in subclass
    }

    open func stop() {
        childCoordinators.forEach { $0.stop() }
        parentCoordinator?.didStop(child: self)
        removeFromParentCoordinator()
    }

    open func add(childCoordinator child: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === child }) else {
            return NSLog(
                "⚠️ Coordinator \(String(describing: self)) - \(#function): Coordinator is already added as child"
            )
        }

        child.parentCoordinator = self
        childCoordinators.append(child)
    }

    open func removeFromParentCoordinator() {
        parentCoordinator?.childCoordinators.removeAll { $0 === self }
        parentCoordinator = nil
    }

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
}
