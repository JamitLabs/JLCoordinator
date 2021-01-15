import JLCoordinator
import XCTest

class InitialNavigationPresenterTests: XCTestCase {
    func testPresentingRootViewController() throws {
        let window: UIWindow = UIWindow()
        let navigationController: UINavigationController = .init()
        let presenter: InitialNavigationPresenter = .init(window: window, with: navigationController)
        let viewController = UIViewController()
        presenter.present(viewController)
        XCTAssertTrue(presenter.window.isKeyWindow)
        XCTAssertEqual(presenter.window.rootViewController, navigationController)
        XCTAssertEqual(navigationController.topViewController, viewController)
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
    }

    func testDismissRoot() throws {
        let window: UIWindow = UIWindow()
        let navigationController: UINavigationController = .init()
        let presenter: InitialNavigationPresenter = .init(window: window, with: navigationController)
        let viewController = UIViewController()
        presenter.present(viewController)
        XCTAssertTrue(presenter.window.isKeyWindow)
        XCTAssertEqual(presenter.window.rootViewController, navigationController)
        presenter.dismissRoot(animated: true)
        XCTAssertTrue(window.isHidden)
    }

    func testPushViewController() throws {
        let observer: MockPresenterObserving = .init()
        let window: UIWindow = .init()
        let navigationController: MockNavigationController = .init()
        let presenter: InitialNavigationPresenter = .init(window: window, with: navigationController)

        let rootViewController: UIViewController = .init()
        presenter.present(rootViewController)
        presenter.register(observer)

        let waitExceptation = expectation(description: "Wait until push is done")
        waitExceptation.expectedFulfillmentCount = 2

        navigationController.didCallPushViewController = { viewController in
            presenter.navigationController(navigationController, didPush: viewController)
            waitExceptation.fulfill()
        }

        let viewControllerToPush: UIViewController = .init()
        observer.didPresentViewControllerClosure = { _, viewController in
            XCTAssertEqual(viewController, viewControllerToPush)
            waitExceptation.fulfill()
        }

        presenter.present(viewControllerToPush)
        wait(for: [waitExceptation], timeout: 1)
    }

    func testPopViewController() throws {
        let observer: MockPresenterObserving = .init()
        let window: UIWindow = .init()
        let navigationController: MockNavigationController = .init()
        let presenter: InitialNavigationPresenter = .init(window: window, with: navigationController)

        let rootViewController: UIViewController = .init()
        presenter.present(rootViewController)

        let viewControllerToPop: UIViewController = .init()
        navigationController.storedViewController = viewControllerToPop
        presenter.register(observer)

        let waitForNavigationControllerCall = expectation(description: "Wait until NavigationController is called.")
        let waitExceptation = expectation(description: "Wait until pop is done")

        navigationController.didCallPopViewController = { viewController in
            guard let viewController = viewController else { return XCTFail("ViewController should be set!") }

            presenter.navigationController(navigationController, didPop: viewController)
            waitForNavigationControllerCall.fulfill()
        }

        observer.didDismissViewControllerClosure = { _, viewController in
            XCTAssertEqual(viewController, viewControllerToPop)
            waitExceptation.fulfill()
        }

        presenter.dismiss(viewControllerToPop)
        wait(for: [waitForNavigationControllerCall, waitExceptation], timeout: 1)
    }
}
