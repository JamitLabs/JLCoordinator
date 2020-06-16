//
//  File.swift
//  CoordinatorBaseTests
//
//  Created by Jens Krug on 15.06.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import CoordinatorBase
import UIKit

final class MockCoordinator: Coordinator {
    var startAction: (() -> Void)?
    var didStopAction: ((Coordinator) -> Void)?
    var didDismissAction: ((Presenter, UIViewController) -> Void)?
    var didPresentAction: ((Presenter, UIViewController) -> Void)?
    var didDismissNavigationController: ((Presenter, UINavigationController) -> Void?)?

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
}
