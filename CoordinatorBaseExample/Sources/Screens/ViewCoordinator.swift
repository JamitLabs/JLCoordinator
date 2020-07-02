//
//  SecondaryCoordinator.swift
//  CoordinatorBaseExample
//
//  Created by Jonathan Gräser on 01.07.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import CoordinatorBase
import UIKit

final class ViewCoordinator: Coordinator {
    private let viewController: ViewController = .init()

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
        let presenterType = type(of: presenter.self)
        if presenterType == ModalNavigationPresenter.self || presenterType == NavigationPresenter.self || presenterType == TabNavigationPresenter.self {
            viewCoordinator = .init(presenter:presenter)
        } else {
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
