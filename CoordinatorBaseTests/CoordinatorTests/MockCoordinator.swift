// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import CoordinatorBase
import UIKit

final class MockCoordinator: Coordinator {
    var startAction: (() -> Void)?
    var didStopAction: ((Coordinator) -> Void)?
    var didDismissAction: ((Presenter, UIViewController) -> Void)?
    var didPresentAction: ((Presenter, UIViewController) -> Void)?
    var didDismissNavigationController: ((Presenter, UINavigationController) -> Void)?
    var didDismissAllViewControllerToRoot: ((Presenter, UINavigationController, UIViewController) -> Void)?

    override func start() {
        super.start()

        startAction?()
    }

    override func didStop(child: Coordinator) {
        super.didStop(child: child)

        didStopAction?(child)
    }

    override func presenter(_ presenter: Presenter, didDismiss viewController: UIViewController) {
        super.presenter(presenter, didDismiss: viewController)

        didDismissAction?(presenter, viewController)
    }

    override func presenter(_ presenter: Presenter, didPresent viewController: UIViewController) {
        super.presenter(presenter, didPresent: viewController)

        didPresentAction?(presenter, viewController)
    }

    override func presenter(_ presenter: Presenter, didDismiss navigationController: UINavigationController) {
        super.presenter(presenter, didDismiss: navigationController)

        didDismissNavigationController?(presenter, navigationController)
    }

    override func presenter(
        _ presenter: Presenter,
        didDismissAllViewControllersTo rootViewController: UIViewController,
        of navigationController: UINavigationController
    ) {
        super.presenter(presenter, didDismissAllViewControllersTo: rootViewController, of: navigationController)
        didDismissAllViewControllerToRoot?(presenter, navigationController, rootViewController)
    }
}
