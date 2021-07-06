import UIKit

public class InitialPresenter: InitialPresenting {
    public let observers: WeakCache<PresenterObserving> = .init()

    public let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = false) {
        guard window.rootViewController === viewController else { return }

        window.isHidden = true
        notifyObserverAboutDismiss(of: viewController)
    }

    public func dismissRoot(animated: Bool) {
        window.isHidden = true
    }

    public func present(_ viewController: UIViewController, animated: Bool = false) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        notifyObserverAboutPresentation(of: viewController)

        if animated {
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: { },
                completion: { _ in }
            )
        }
    }
}
