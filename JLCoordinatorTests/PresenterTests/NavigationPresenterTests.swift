import JLCoordinator
import XCTest

class NavigationPresenterTests: XCTestCase {
    func testPushViewController() throws {
        let observer: MockPresenterObserving = .init()
        let navigationController: MockNavigationController = .init()
        let presenter: NavigationPresenter = .init(navigationController: navigationController)
        presenter.register(observer)
        let waitExceptation = expectation(description: "Wait until push is done")
        waitExceptation.expectedFulfillmentCount = 2

        navigationController.didCallPushViewController = { viewController in
            presenter.navigationController(navigationController, didPush: viewController)
            waitExceptation.fulfill()
        }

        let viewControllerToPush: UIViewController = .init()
        observer.didPresentViewControllerClosure = { _, viewController in
            XCTAssertTrue(viewController === viewControllerToPush)
            waitExceptation.fulfill()
        }

        presenter.present(viewControllerToPush)
        wait(for: [waitExceptation], timeout: 1)
    }

    func testPopViewController() throws {
        let observer: MockPresenterObserving = .init()
        let navigationController: MockNavigationController = .init()
        let presenter: NavigationPresenter = .init(navigationController: navigationController)
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
            XCTAssertTrue(viewController === viewControllerToPop)
            waitExceptation.fulfill()
        }

        presenter.dismiss(viewControllerToPop)
        wait(for: [waitForNavigationControllerCall, waitExceptation], timeout: 1)
    }

    func testViewControllerIsNotPoppedIfItIsNotTop() {
        let observer: MockPresenterObserving = .init()
        let navigationController: MockNavigationController = .init()
        let presenter: NavigationPresenter = .init(navigationController: navigationController)
        let viewControllerToPop: UIViewController = .init()
        navigationController.storedViewController = .init()

        presenter.register(observer)

        let waitUntilAllCallsMade = expectation(description: "Wait until pop is done")
        waitUntilAllCallsMade.isInverted = true

        navigationController.didCallPopViewController = { viewController in
            XCTFail("Should not be called!")
        }

        observer.didDismissViewControllerClosure = { _, viewController in
            XCTFail("Should not be called!")
        }

        presenter.dismiss(viewControllerToPop)
        wait(for: [waitUntilAllCallsMade], timeout: 1)
    }
}
