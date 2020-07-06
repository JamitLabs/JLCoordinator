// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import CoordinatorBase
import UIKit

final class ViewCoordinator: Coordinator {
    private let viewController: ViewController = UIStoryboard(name: "ViewController", bundle: nil).instantiateViewController(identifier: "ViewController")

    override func start() {
        viewController.delegate = self
        presenter.present(viewController, animated: true)
    }
}

extension ViewCoordinator: ViewControllerDelegate {
    func didTriggerModalViewController(in viewController: ViewController) {
        let viewCoordinator = ViewCoordinator(presenter: ModalPresenter(presentingViewController: viewController))
        add(childCoordinator: viewCoordinator)
        viewCoordinator.start()
    }

    func didTriggerModalNavigationController(in viewController: ViewController) {
        let viewCoordinator: ViewCoordinator = .init(presenter: ModalNavigationPresenter(presentingViewController: viewController))
        add(childCoordinator: viewCoordinator)
        viewCoordinator.start()
    }

    func didTriggerPushViewController(in viewController: ViewController) {
        let viewCoordinator: ViewCoordinator
        switch presenter {
        case is ModalNavigationPresenter, is NavigationPresenter, is TabNavigationPresenter:
            viewCoordinator = .init(presenter:presenter)

        default:
            viewCoordinator = .init(presenter: ModalNavigationPresenter(presentingViewController: viewController))
        }

        add(childCoordinator: viewCoordinator)
        viewCoordinator.start()
    }

    func didTriggerModalTabController(in viewController: ViewController) {
        let tabCoordinator: TabCoordinator = .init(presenter: ModalPresenter(presentingViewController: viewController))
        add(childCoordinator: tabCoordinator)
        tabCoordinator.start()
        tabCoordinator.addTab { tabBarController -> Coordinator in
            return ViewCoordinator(presenter: TabPresenter(tabBarController: tabBarController))
        }
    }

    func didTriggerModalTabNavigationController(in viewController: ViewController) {
        let tabCoordinator: TabCoordinator = .init(presenter: ModalPresenter(presentingViewController: viewController))
        add(childCoordinator: tabCoordinator)
        tabCoordinator.start()
        tabCoordinator.addTab { tabBarController -> Coordinator in
            return ViewCoordinator(presenter: TabNavigationPresenter(tabBarController: tabBarController))
        }
    }

    func didTriggerAddTab(in viewController: ViewController) {
        guard let addTabDelegate = addTabDelegate else {
            return didTriggerModalTabController(in: viewController)
        }

        addTabDelegate.addTab { tabBarController -> Coordinator in
            return ViewCoordinator(presenter: TabPresenter(tabBarController: tabBarController))
        }
    }

    func didTriggerAddTabNavigation(in viewController: ViewController) {
        guard let addTabDelegate = addTabDelegate else {
            return didTriggerModalTabNavigationController(in: viewController)
        }

        addTabDelegate.addTab { tabBarController -> Coordinator in
            return ViewCoordinator(presenter: TabNavigationPresenter(tabBarController: tabBarController))
        }
    }

    func didTriggerCloseButton(in viewController: ViewController) {
        presenter.dismiss(viewController, animated: true)
    }
}
