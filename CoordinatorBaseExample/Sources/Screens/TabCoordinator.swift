// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import CoordinatorBase
import UIKit

final class TabCoordinator: Coordinator {
    private let tabBarController: UITabBarController = .init()

    override func start() {
        presenter.present(tabBarController, animated: true)
    }
}

extension TabCoordinator: AddTabDelegate {
    func addTab(for coordinator: (UITabBarController) -> Coordinator) {
        let coordinatorToAdd = coordinator(tabBarController)
        guard let tabPresenting = coordinatorToAdd.presenter as? TabPresenting else {
            fatalError("Presenter of view controller to add in a tabBar isn't of type TabPresenting. This is not allowed.")
        }

        tabPresenting.tabBarItemDelegate = self
        coordinatorToAdd.addTabDelegate = self
        add(childCoordinator: coordinatorToAdd)
        coordinatorToAdd.start()
    }
}

extension TabCoordinator: TabBarItemDelegate {
    func tabPresenter(_ presenter: TabPresenting, presentsViewController viewController: UIViewController, atTabBarIndex index: Int) {
        viewController.tabBarItem = .init(title: "View \(index + 1)", image: nil, tag: index)
    }
}
