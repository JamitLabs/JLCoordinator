// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import XCTest
import CoordinatorBase
@testable import CoordinatorBaseExample

final class MockPresenter: Presenter {
    var presentCallBack: (() -> Void)?
    var dismissCallBack: (() -> Void)?
    var dismissRootCallBack: (() -> Void)?

    var observers: WeakCache<PresenterObserving> = .init()

    func dismiss(_ viewController: UIViewController, animated: Bool) {
        dismissCallBack?()
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        _ = viewController.view
        presentCallBack?()
    }

    func dismissRoot(animated: Bool) {
        dismissRootCallBack?()
    }
}

final class MockTabPresenter: Presenter, TabPresenting {
    var presentCallBack: (() -> Void)?
    var dismissCallBack: (() -> Void)?
    var dismissRootCallBack: (() -> Void)?

    var observers: WeakCache<PresenterObserving> = .init()
    var tabBarController: UITabBarController

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    func dismiss(_ viewController: UIViewController, animated: Bool) {
        dismissCallBack?()
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        _ = viewController.view
        presentCallBack?()
    }

    func dismissRoot(animated: Bool) {
        dismissRootCallBack?()
    }
}

final class TabCoordinatorTests: XCTestCase {
    func testStart() {
        let mockPresenter: MockPresenter = .init()
        let waitExp = expectation(description: "waitForPresentation")

        mockPresenter.presentCallBack = { waitExp.fulfill() }

        let tabCoordinator: TabCoordinator = .init(presenter: mockPresenter)

        tabCoordinator.start()
        wait(for: [waitExp], timeout: 1)
    }
}
