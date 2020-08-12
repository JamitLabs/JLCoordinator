// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

@testable import JLCoordinator
import XCTest

class ModalNavigationPresenterTests: XCTestCase {
    func testInitialPresentationOfViewController() throws {
        let observer: MockPresenterObserving = .init()
        let presentingViewController: MockPresentingViewController = .init()
        let modalNavigationPresenter: ModalNavigationPresenter = .init(presentingViewController: presentingViewController)
        let viewControllerToPresent: UIViewController = .init()
        modalNavigationPresenter.register(observer)

        validate(
            that: viewControllerToPresent,
            presentedOnMock: presentingViewController,
            presentedBy: modalNavigationPresenter,
            observedBy: observer
        )
    }

    private func validate(
        that viewControllerToPresent: UIViewController,
        presentedOnMock presentingViewController: MockPresentingViewController,
        presentedBy presenter: ModalNavigationPresenter,
        observedBy observer: MockPresenterObserving
    ) {
        let finishedPresentation = expectation(description: "Wait until presentation has been finished!")
        
        presentingViewController.didCallPresentFunction = { viewController, flag in
            XCTAssertTrue(viewController is UINavigationController)
            XCTAssertTrue(flag)
            XCTAssertTrue((viewController as? UINavigationController)?.viewControllers.isEmpty == false)
            finishedPresentation.fulfill()
        }
        
        let waitForObserverCall = expectation(description: "Observer called")
        waitForObserverCall.expectedFulfillmentCount = 2
        observer.didPresentViewControllerClosure = { observedPresenter, viewController in
            XCTAssertTrue(presenter === observedPresenter)
            XCTAssertTrue(
                viewController === viewControllerToPresent
                || viewController is UINavigationController
            )
            waitForObserverCall.fulfill()
        }

        presenter.present(viewControllerToPresent, animated: true)
        wait(for: [finishedPresentation, waitForObserverCall], timeout: 1)
    }

    func testPushViewController() throws {
        let observer: MockPresenterObserving = .init()
        let presentingViewController: MockPresentingViewController = .init()
        let presenter: ModalNavigationPresenter = .init(presentingViewController: presentingViewController)
        presenter.register(observer)

        let mockNavigationController: MockNavigationController = .init(rootViewController: .init())
        mockNavigationController.mockPresentingViewController = presentingViewController
        presenter.navigationController = mockNavigationController

        let viewControllerToPresent: UIViewController = .init()
        let waitExceptation = expectation(description: "Wait until push is done")
        waitExceptation.expectedFulfillmentCount = 2

        mockNavigationController.didCallPushViewController = { viewController in
            XCTAssertTrue(viewControllerToPresent === viewController)
            presenter.navigationController(mockNavigationController, didPush: viewController)
            waitExceptation.fulfill()
        }

        observer.didPresentViewControllerClosure = { observedPresenter, viewController in
            XCTAssertTrue(presenter === observedPresenter)
            XCTAssertTrue(viewController === viewControllerToPresent)
            waitExceptation.fulfill()
        }

        presenter.present(viewControllerToPresent)
        wait(for: [waitExceptation], timeout: 1)
    }

    func testPopViewController() throws {
        let observer: MockPresenterObserving = .init()
        let navigationController: MockNavigationController = .init()
        let mockPresentingViewController: MockPresentingViewController = .init()
        let presenter: ModalNavigationPresenter = .init(presentingViewController: mockPresentingViewController)
        presenter.navigationController = navigationController

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
