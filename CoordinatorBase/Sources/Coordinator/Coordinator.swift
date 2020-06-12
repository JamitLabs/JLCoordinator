// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import Foundation
import UIKit

open class Coordinator: PresenterObserving {
    public var childCoordinators: [Coordinator] = []
    public weak var parentCoordinator: Coordinator?
    var presenter: Presenter {
        didSet {
            oldValue.unregister(self)
            presenter.register(self)
        }
    }

    init(presenter: Presenter) {
        self.presenter = presenter
        self.presenter.register(self)
        NSLog("INIT Coordinator %@ ", String(describing: self))
    }

    deinit {
        NSLog("DEINIT Coordinator %@ ", String(describing: self))
    }

    public func start() {
        // Should be overriden in subclass
    }

    public func stop() {
        childCoordinators.forEach { $0.stop() }
        parentCoordinator?.didStop(child: self)
        removeFromParentCoordinator()
    }

    public func add(childCoordinator child: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === child }) else {
            return NSLog("⚠️ Coordinator \(String(describing: self)) - \(#function): Coordinator is already added as child")
        }

        child.parentCoordinator = self
        childCoordinators.append(child)
    }

    public func removeFromParentCoordinator() {
        parentCoordinator?.childCoordinators.removeAll { $0 === self }
        parentCoordinator = nil
    }

    func didStop(child: Coordinator) {
        // Called if child has been stopped
    }

    public func presenter(_ presenter: Presenter, didDismiss viewController: UIViewController) {
        // Override in subclass
    }

    public func presenter(_ presenter: Presenter, didPresent viewController: UIViewController) {
        // Override in sublcass
    }

    public func presenter(_ presenter: Presenter, didDismiss navigationController: UINavigationController) {
        // Override in sublclass
    }
}
