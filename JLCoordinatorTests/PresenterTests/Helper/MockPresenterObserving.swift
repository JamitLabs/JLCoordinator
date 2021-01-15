import JLCoordinator
import UIKit

final class MockPresenterObserving: PresenterObserving {
    var didPresentViewControllerClosure: ((Presenter, UIViewController) -> Void)?
    var didDismissViewControllerClosure: ((Presenter, UIViewController) -> Void)?
    var didDismissNavigationControllerClosure: ((Presenter, UINavigationController) -> Void)?
    var didDismissAllViewControllerToRootViewControllerClosure: ((Presenter, UINavigationController, UIViewController) -> Void)?

    func presenter(_ presenter: Presenter, didPresent viewController: UIViewController) {
        didPresentViewControllerClosure?(presenter, viewController)
    }

    func presenter(_ presenter: Presenter, didDismiss viewController: UIViewController) {
        didDismissViewControllerClosure?(presenter, viewController)
    }

    func presenter(_ presenter: Presenter, didDismiss navigationController: UINavigationController) {
        didDismissNavigationControllerClosure?(presenter, navigationController)
    }

    func presenter(
        _ presenter: Presenter,
        didDismissAllViewControllersTo rootViewController: UIViewController,
        of navigationController: UINavigationController
    ) {
        didDismissAllViewControllerToRootViewControllerClosure?(presenter, navigationController, rootViewController)
    }
}
