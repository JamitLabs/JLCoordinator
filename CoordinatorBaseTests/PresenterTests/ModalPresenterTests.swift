// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

@testable import CoordinatorBase
import XCTest

class ModalPresenterTests: XCTestCase {
    var observing: MockPresenterObserving!

    override func setUp() {
        super.setUp()

        observing = .init()
    }

    func testPresentViewController() throws {
        let presentingViewController = MockPresentingViewController()
        let modalPresenter: ModalPresenter = .init(presentingViewController: presentingViewController)
        let viewControllerToPresent: UIViewController = .init()

        modalPresenter.register(observing)
        let finishedPresentation = XCTestExpectation(description: "Wait until presentation has been finished!")
        finishedPresentation.expectedFulfillmentCount = 2

        presentingViewController.didCallPresentFunction = { viewController, flag in
            XCTAssertTrue(viewController === viewControllerToPresent)
            XCTAssertTrue(flag)
            finishedPresentation.fulfill()
        }

        observing.didPresentViewControllerClosure = { presenter, viewController in
            XCTAssertTrue(presenter === modalPresenter)
            XCTAssertTrue(viewController === viewControllerToPresent)
            finishedPresentation.fulfill()
        }

        modalPresenter.present(viewControllerToPresent, animated: true)
        wait(for: [finishedPresentation], timeout: 1)
    }

    func testDismissViewController() throws {
        let presentingViewController: MockPresentingViewController = .init()
        let modalPresenter: ModalPresenter = .init(presentingViewController: presentingViewController)
        let viewControllerToDismiss: MockPresentingViewController = .init()

        modalPresenter.register(observing)

        let finishedPresentation = XCTestExpectation(description: "Wait until presentation has been finished!")

        finishedPresentation.expectedFulfillmentCount = 2

        presentingViewController.presentedViewControllerForTest = { viewControllerToDismiss }

        viewControllerToDismiss.didCallDismissFunction = { viewController, flag in
            XCTAssertTrue(viewControllerToDismiss === viewController)
            XCTAssertTrue(flag)
            finishedPresentation.fulfill()
        }

        observing.didDismissViewControllerClosure = { presenter, viewController in
            XCTAssertTrue(presenter === modalPresenter)
            XCTAssertTrue(viewControllerToDismiss === viewController)
            finishedPresentation.fulfill()
        }

        modalPresenter.dismiss(viewControllerToDismiss, animated: true)
        wait(for: [finishedPresentation], timeout: 1)
    }

    func testDismissIsOnlyCalledForTopMostViewController() throws {
        let presentingViewController: MockPresentingViewController = .init()
        let modalPresenter: ModalPresenter = .init(presentingViewController: presentingViewController)
        let viewControllerToDismiss: MockPresentingViewController = .init()

        presentingViewController.presentedViewControllerForTest = { UIViewController() }
        viewControllerToDismiss.didCallDismissFunction = { viewController, flag in
            XCTFail("Dismiss should never be called on this ViewController")
        }

        observing.didDismissViewControllerClosure = { presenter, viewController in
            XCTFail("Dismiss should never be called on this ViewController")
        }

        modalPresenter.dismiss(viewControllerToDismiss, animated: true)

        let finishedPresentation = XCTestExpectation(description: "Wait until presentation has been finished!")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            finishedPresentation.fulfill()
        }

        wait(for: [finishedPresentation], timeout: 1)
    }

    func testAdaptiveDismissNotifying() throws {
        let presentingViewController: MockPresentingViewController = .init()
        let modalPresenter: ModalPresenter = .init(presentingViewController: presentingViewController)
        modalPresenter.register(observing)

        let viewControllerToDismiss: UIViewController = .init()
        let finishedPresentation = XCTestExpectation(description: "Wait until presentation has been finished!")

        observing.didDismissViewControllerClosure = { presenter, viewController in
            XCTAssertTrue(presenter === modalPresenter)
            XCTAssertTrue(viewControllerToDismiss === viewController)
            finishedPresentation.fulfill()
        }

        modalPresenter.adaptiveDidDismiss(viewControllerToDismiss)
        wait(for: [finishedPresentation], timeout: 1)
    }
}
