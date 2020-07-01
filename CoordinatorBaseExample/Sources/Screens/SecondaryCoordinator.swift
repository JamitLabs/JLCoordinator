//
//  SecondaryCoordinator.swift
//  CoordinatorBaseExample
//
//  Created by Jonathan Gräser on 01.07.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import CoordinatorBase

final class SecondaryCoordinator: Coordinator {
    private let viewController: ViewController = .init()

    override func start() {
        presenter.present(viewController, animated: true)
    }
}
