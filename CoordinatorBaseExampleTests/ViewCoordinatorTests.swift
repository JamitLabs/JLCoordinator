//
//  ViewCoordinatorTests.swift
//  CoordinatorBaseExampleTests
//
//  Created by Jonathan Gräser on 03.07.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import XCTest
import CoordinatorBase
@testable import CoordinatorBaseExample

final class MockAddTabDelegate: AddTabDelegate {
    var addTabCallBack: (() -> Void)?

    func addTab(for coordinator: (UITabBarController) -> Coordinator) {
        addTabCallBack?()
        _ = coordinator(UITabBarController())
    }
}

final class ViewCoordinatorTests: XCTestCase {
    func testStart() {
        let mockPresenter: MockPresenter = .init()
        let waitExp = expectation(description: "waitForPresentation")

        mockPresenter.presentCallBack = { waitExp.fulfill() }

        let viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.start()
        wait(for: [waitExp], timeout: 1)
    }

    func testDidTriggerModalViewController() {
        let mockPresenter: MockPresenter = .init()
        let viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.didTriggerModalViewController(in: .init())
        XCTAssert(viewCoordinator.childCoordinators.count == 1)
    }

    func testDidTriggerModalNavigationController() {
        let mockPresenter: MockPresenter = .init()
        let viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.didTriggerModalNavigationController(in: .init())
        XCTAssert(viewCoordinator.childCoordinators.count == 1)
    }

    func testDidTriggerPushViewController() {
        let mockPresenter: MockPresenter = .init()
        let viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.didTriggerPushViewController(in: .init())
        XCTAssert(viewCoordinator.childCoordinators.count == 1)
    }

    func testDidTriggerModalTabController() {
        let mockPresenter: MockPresenter = .init()
        let viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.didTriggerModalTabController(in: .init())
        XCTAssert(viewCoordinator.childCoordinators.count == 1)
    }

    func testDidTriggerModalTabNavigationController() {
        let mockPresenter: MockPresenter = .init()
        let viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.didTriggerModalTabNavigationController(in: .init())
        XCTAssert(viewCoordinator.childCoordinators.count == 1)
    }

    func testDidTriggerAddTab() {
        let waitExp = expectation(description: "waitForAddTabCallback")
        let mockPresenter: MockPresenter = .init()
        let mockAddTabDelegate: MockAddTabDelegate = .init()
        mockAddTabDelegate.addTabCallBack = { waitExp.fulfill() }
        var viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)

        viewCoordinator.addTabDelegate = mockAddTabDelegate
        viewCoordinator.didTriggerAddTab(in: .init())
        wait(for: [waitExp], timeout: 1)

        viewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.didTriggerAddTabNavigation(in: .init())
        XCTAssert(viewCoordinator.childCoordinators.count == 1)
    }

    func testDidTriggerAddTabNavigation() {
        let waitExp = expectation(description: "waitForAddTabCallback")
        let mockPresenter: MockPresenter = .init()
        let mockAddTabDelegate: MockAddTabDelegate = .init()
        mockAddTabDelegate.addTabCallBack = { waitExp.fulfill() }
        var viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)

        viewCoordinator.addTabDelegate = mockAddTabDelegate
        viewCoordinator.didTriggerAddTabNavigation(in: .init())
        wait(for: [waitExp], timeout: 1)

        viewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.didTriggerAddTabNavigation(in: .init())
        XCTAssert(viewCoordinator.childCoordinators.count == 1)
    }

    func testDidTriggerCloseButton() {
        let mockPresenter: MockPresenter = .init()
        let waitExp = expectation(description: "waitForDismissal")

        mockPresenter.dismissCallBack = { waitExp.fulfill() }
        let viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.didTriggerCloseButton(in: .init())
        wait(for: [waitExp], timeout: 1)
    }
}
