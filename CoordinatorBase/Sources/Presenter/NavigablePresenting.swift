// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public protocol NavigablePresenting: Presenter {
    /// The `navigationController` which can push `viewControllers`
    var navigationController: UINavigationController { get }

    /// Pushes the `viewController` on the `navigationController`
    /// - parameters:
    ///     - viewController: The `viewController` which should be pushed
    ///     - animated: A flag that defines if the push should be animated
    func push(_ viewController: UIViewController, animated: Bool)

    /// Pops the `viewController` from the `navigationController`
    /// - parameters:
    ///     - viewController: The `viewController` which should be popped
    ///     - animated: A flag that defines if the pop should be animated
    func pop(_ viewController: UIViewController, animated: Bool)
}

extension NavigablePresenting {
    public func push(_ viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    public func pop(_ viewController: UIViewController, animated: Bool) {
        guard navigationController.topViewController === viewController else { return }

        navigationController.popViewController(animated: animated)
    }
}
