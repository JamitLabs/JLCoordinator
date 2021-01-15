import Foundation
import UIKit

public protocol NavigablePresenting: Presenter {
    /// The `navigationController` which can push `viewControllers`
    var navigationController: UINavigationController? { get }

    /// Pushes the `viewController` on the `navigationController`
    /// - parameters:
    ///     - viewController: The `viewController` which should be pushed
    ///     - animated: A flag that defines if the push should be animated
    func push(_ viewController: UIViewController, animated: Bool)

    /// Pops the `viewController` from the `navigationController` but only if it is the topViewController of the
    /// ViewController stack of the `navigationController`
    /// - parameters:
    ///     - viewController: The `viewController` which should be popped
    ///     - animated: A flag that defines if the pop should be animated
    func pop(_ viewController: UIViewController, animated: Bool)
}

// swiftLint:disable multiline_arguments_brackets
extension NavigablePresenting {
    public func push(_ viewController: UIViewController, animated: Bool) {
        guard let navigationController = navigationController else {
            NSLog("⚠️ UINavigationController is nil in %@ - \(#function).", String(describing: self))
            return
        }

        navigationController.pushViewController(viewController, animated: animated)
    }

    public func pop(_ viewController: UIViewController, animated: Bool) {
        guard let navigationController = navigationController else {
            NSLog(
                "⚠️ UINavigationController is nil in %@ - \(#function), while trying to push UIViewController %@",
                String(describing: self),
                String(describing: viewController)
            )

            return
        }

        guard navigationController.topViewController === viewController else {
            NSLog(
                "⚠️ \(#function) Trying to pop UIViewController %@ which is not the TopViewController of UINavigationController in %@",
                String(describing: viewController),
                String(describing: self)
            )

            return
        }

        navigationController.popViewController(animated: animated)
    }
}
