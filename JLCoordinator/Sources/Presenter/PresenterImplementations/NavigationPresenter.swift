import UIKit

public class NavigationPresenter: NavigablePresenting {
    public let observers: WeakCache<PresenterObserving> = .init()
    public var navigationController: UINavigationController?
    private let delegateWrapper: NavigationControllerDelegateWrapper = .init()

    public init(navigationController: UINavigationController) {
        assert(
            navigationController.viewControllers.isEmpty,
            "Trying to intialise NavigationPresenter with an non empty UINavigationController. This is not allowed!"
        )

        self.navigationController = navigationController
        delegateWrapper.delegate = self
        navigationController.delegate = delegateWrapper
    }

    public func present(_ viewController: UIViewController, animated: Bool = true) {
        push(viewController, animated: animated)
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        pop(viewController, animated: animated)
    }

    public func dismissRoot(animated: Bool) {
        guard navigationController?.presentingViewController != nil else { return }

        navigationController?.dismiss(animated: animated) { [weak self] in
            guard let navigationController = self?.navigationController else { return }

            self?.notifyObserverAboutDismiss(of: navigationController)
            navigationController.viewControllers.forEach {
                self?.notifyObserverAboutDismiss(of: $0)
            }
        }
    }
}

extension NavigationPresenter: NavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        didPop viewController: UIViewController
    ) {
        notifyObserverAboutDismiss(of: viewController)
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        didPush viewController: UIViewController
    ) {
        notifyObserverAboutPresentation(of: viewController)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        didPopToRootViewController rootViewController: UIViewController
    ) {
        notifyObserverAboutDismissOfAllViewControllers(but: rootViewController, of: navigationController)
    }
}
