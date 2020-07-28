// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import CoordinatorBase
import XCTest

class InitialPresenterTests: XCTestCase {
    func testPresentingViewController() throws {
        let window: UIWindow = UIWindow()
        let presenter: InitialPresenter = InitialPresenter(window: window)
        let viewController = UIViewController()
        presenter.present(viewController)
        XCTAssertTrue(presenter.window.isKeyWindow)
        XCTAssertTrue(presenter.window.rootViewController === viewController)
        XCTAssertTrue(viewController.isViewLoaded)
    }

    func testDismissViewController() throws {
        // Initialize window and viewcontroller
        let window: UIWindow = UIWindow()
        let presenter: InitialPresenter = InitialPresenter(window: window)
        let viewController = UIViewController()
        presenter.present(viewController)
        XCTAssertTrue(presenter.window.isKeyWindow)
        XCTAssertTrue(presenter.window.rootViewController === viewController)
        XCTAssertTrue(viewController.isViewLoaded)

        // Dismiss ViewController
        presenter.dismiss(viewController)
        XCTAssertTrue(window.isHidden)
    }

    func testDismissRoot() throws {
        let window: UIWindow = UIWindow()
        let presenter: InitialPresenter = InitialPresenter(window: window)
        let viewController = UIViewController()
        presenter.present(viewController)
        XCTAssertTrue(presenter.window.isKeyWindow)
        XCTAssertTrue(presenter.window.rootViewController === viewController)
        XCTAssertTrue(viewController.isViewLoaded)
        presenter.dismissRoot(animated: true)
        XCTAssertTrue(window.isHidden)
    }
}
