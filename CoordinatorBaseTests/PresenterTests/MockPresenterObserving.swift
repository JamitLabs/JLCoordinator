//
//  MockPresenterObserving.swift
//  CoordinatorBaseTests
//
//  Created by Jens Krug on 19.06.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import CoordinatorBase
import UIKit

final class MockPresenterObserving: PresenterObserving {
    var didPresentViewControllerClosure: ((Presenter, UIViewController) -> Void)?
    var didDismissViewControllerClosure: ((Presenter, UIViewController) -> Void)?
    var didDismissNavigationControllerClosure: ((Presenter, UINavigationController) -> Void)?

    func presenter(_ presenter: Presenter, didPresent viewController: UIViewController) {
        didPresentViewControllerClosure?(presenter, viewController)
    }

    func presenter(_ presenter: Presenter, didDismiss viewController: UIViewController) {
        didDismissViewControllerClosure?(presenter, viewController)
    }

    func presenter(_ presenter: Presenter, didDismiss navigationController: UINavigationController) {
        didDismissNavigationControllerClosure?(presenter, navigationController)
    }
}
