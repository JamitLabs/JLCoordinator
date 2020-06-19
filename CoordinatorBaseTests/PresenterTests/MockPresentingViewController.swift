//
//  MockPresentingViewController.swift
//  CoordinatorBaseTests
//
//  Created by Jens Krug on 19.06.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import UIKit

class MockPresentingViewController: UIViewController {
    var didCallPresentFunction: ((UIViewController, Bool) -> Void)?
    var didCallDismissFunction: ((UIViewController?, Bool) -> Void)?

    var presentedViewControllerForTest: (() -> UIViewController?)?

    override var presentedViewController: UIViewController? {
        presentedViewControllerForTest?()
    }

    override func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool, completion: (() -> Void)? = nil
    ) {
        didCallPresentFunction?(viewControllerToPresent, flag)
        completion?()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didCallDismissFunction?(self, flag)
        completion?()
    }
}
