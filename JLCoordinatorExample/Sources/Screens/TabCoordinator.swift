// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import JLCoordinator
import UIKit

final class TabCoordinator: Coordinator, CoordinatorObserving {
    private let tabBarController: UITabBarController = .init()

    override init(presenter: Presenter) {
        super.init(presenter: presenter)

        // NOTE: This is just used to supervise the number of coordinatores and the allocation and deallocation of them.
        CoordinatorCounter.shared.register(self)
    }

    override func didRemove(child: Coordinator) {
        super.didRemove(child: child)

        guard !childCoordinators.isEmpty else { return }

        stop()
    }

    override func start() {
        presenter.present(tabBarController, animated: true)

        let tabPresenter = TabPresenter(tabBarController: tabBarController)
        let tabNavigationCoordinator = TabNavigationPresenter(tabBarController: tabBarController)

        let firstCoordinator = ViewCoordinator(presenter: tabPresenter)
        add(childCoordinator: firstCoordinator)
        firstCoordinator.start()

        let secondCoordinator = ViewCoordinator(presenter: tabPresenter)
        add(childCoordinator: secondCoordinator)
        secondCoordinator.start()

        let thirdCoordinator = ViewCoordinator(presenter: tabNavigationCoordinator)
        add(childCoordinator: thirdCoordinator)
        thirdCoordinator.start()
    }

    override func presenter(_ presenter: Presenter, didDismiss viewController: UIViewController) {
        guard viewController === tabBarController else { return }

        stop()
    }

    deinit {
        CoordinatorCounter.shared.unregister(self)
    }
}
