import UIKit

class MockPresentingViewController: UIViewController {
    var didCallPresentFunction: ((UIViewController, Bool) -> Void)?
    var didCallDismissFunction: ((UIViewController?, Bool) -> Void)?

    var presentedViewControllerForTest: (() -> UIViewController?)?

    override var presentedViewController: UIViewController? {
        presentedViewControllerForTest?()
    }

    override func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool, completion: (() -> Void)? = nil
    ) {
        didCallPresentFunction?(viewControllerToPresent, flag)
        completion?()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didCallDismissFunction?(self, flag)
        completion?()
    }
}
