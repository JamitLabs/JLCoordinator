import UIKit

public class InitialNavigationPresenter: NavigationPresenter, InitialPresenting {
    public var window: UIWindow

    public init(window: UIWindow, with navigationController: UINavigationController = .init()) {
        self.window = window
        super.init(navigationController: navigationController)
    }

    override public func present(_ viewController: UIViewController, animated: Bool = true) {
        // Set navigation controller as root view controller if needed.
        if window.rootViewController !== navigationController {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }

        super.present(viewController, animated: animated)
    }

    override public func dismissRoot(animated: Bool) {
        window.isHidden = true

        navigationController.flatMap {
            notifyObserverAboutDismiss(of: $0)
            $0.viewControllers.forEach(notifyObserverAboutDismiss(of:))
        }
    }
}
