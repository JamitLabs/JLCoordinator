//
//  MainCoordinator.swift
//  CoordinatorBaseExample
//
//  Created by Jonathan Gräser on 01.07.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import CoordinatorBase
import UIKit

final class MainCoordinator: Coordinator {
    private let tabBarController: UITabBarController = .init()

    override func start() {
        presenter.present(tabBarController, animated: true)

        let tabPresenter = TabPresenter(tabBarController: tabBarController)
        tabPresenter.tabBarItemDataSource = self
        let firstChild = SecondaryCoordinator(presenter: tabPresenter)
        let secondChild = SecondaryCoordinator(presenter: tabPresenter)
        add(childCoordinator: firstChild)
        firstChild.start()
        add(childCoordinator: secondChild)
        secondChild.start()
    }
}

extension MainCoordinator: TabBarItemDataSource {
    func tabPresenter(_ presenter: TabPresenter, tabBarItemAtIndex index: Int) -> UITabBarItem? {
        return .init(title: "View \(index + 1)", image: nil, tag: index)
    }
}
