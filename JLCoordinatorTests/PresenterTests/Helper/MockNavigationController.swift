import UIKit

final class MockNavigationController: UINavigationController {
    var didCallPushViewController: ((UIViewController) ->  Void)?
    var didCallPopViewController: ((UIViewController?) -> Void)?
    var storedViewController: UIViewController?
    var mockPresentingViewController: UIViewController?

    override var presentingViewController: UIViewController? {
        return mockPresentingViewController
    }

    override var topViewController: UIViewController? {
        return storedViewController
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        defer { storedViewController = viewController }

        didCallPushViewController?(viewController)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        defer { storedViewController = nil }

        didCallPopViewController?(storedViewController)
        return storedViewController
    }
}
