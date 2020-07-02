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
    func didTriggerModalNavigationController(in viewController: ViewController) {
        let secondaryCoordinator: ViewCoordinator = .init(presenter: ModalNavigationPresenter(presentingViewController: viewController))
        add(childCoordinator: secondaryCoordinator)
        secondaryCoordinator.start()
    }

    func didTriggerPushViewController(in viewController: ViewController) {
        let secondaryCoordinator: ViewCoordinator
        let presenterType = type(of: presenter.self)
        if presenterType == ModalNavigationPresenter.self || presenterType == NavigationPresenter.self || presenterType == TabNavigationPresenter.self {
            secondaryCoordinator = .init(presenter:presenter)
        } else {
            secondaryCoordinator = .init(presenter: ModalNavigationPresenter(presentingViewController: viewController))
        }

        add(childCoordinator: secondaryCoordinator)
        secondaryCoordinator.start()
    }

    func didTriggerModalTabController(in viewController: ViewController) {
        let tabCoordinator: TabCoordinator = .init(presenter: ModalPresenter(presentingViewController: viewController))
        add(childCoordinator: tabCoordinator)
        tabCoordinator.start()
        tabCoordinator.addTab { tabBarController -> Coordinator in
            return ViewCoordinator(presenter: TabPresenter(tabBarController: tabBarController))
        }
    }

    func didTriggerAddTab(in viewController: ViewController) {
        guard let addTabDelegate = addTabDelegate else {
            didTriggerModalTabController(in: viewController)
            return
        }

        addTabDelegate.addTab { tabBarController -> Coordinator in
            return ViewCoordinator(presenter: TabPresenter(tabBarController: tabBarController))
        }
    }
}
