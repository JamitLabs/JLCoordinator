//
//  TabCoordinatorTests.swift
//  CoordinatorBaseExampleTests
//
//  Created by Jonathan Gräser on 03.07.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import XCTest
import CoordinatorBase
@testable import CoordinatorBaseExample

final class MockPresenter: Presenter {
    var presentCallBack: (() -> Void)?
    var dismissCallBack: (() -> Void)?

    var observers: WeakCache<PresenterObserving> = .init()

    func dismiss(_ viewController: UIViewController, animated: Bool) {
        dismissCallBack?()
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        presentCallBack?()
    }
}

final class MockTabPresenter: Presenter, TabPresenting {
    var presentCallBack: (() -> Void)?
    var dismissCallBack: (() -> Void)?

    var observers: WeakCache<PresenterObserving> = .init()
    var tabBarController: UITabBarController
    weak var tabBarItemDelegate: TabBarItemDelegate?

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    func dismiss(_ viewController: UIViewController, animated: Bool) {
        dismissCallBack?()
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        presentCallBack?()
    }
}

final class MockCoordinator: Coordinator {
    var startCallBack: (() -> Void)?

    override func start() {
        startCallBack?()
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

    func testAddTab() {
        let mockPresenter: MockPresenter = .init()
        let waitExp = expectation(description: "waitForStart")
        var mockCoordinator: MockCoordinator = .init(presenter: mockPresenter)

        let tabCoordinator: TabCoordinator = .init(presenter: mockPresenter)
        var mockTabPresenter: MockTabPresenter?
        tabCoordinator.addTab { tabController -> Coordinator in
            mockTabPresenter = .init(tabBarController: tabController)
            mockCoordinator = .init(presenter: mockTabPresenter!)

            mockCoordinator.startCallBack = { waitExp.fulfill() }
            return mockCoordinator
        }

        wait(for: [waitExp], timeout: 1)

        XCTAssert(mockCoordinator.addTabDelegate === tabCoordinator)
        XCTAssert(mockTabPresenter != nil)
        XCTAssert(mockTabPresenter?.tabBarItemDelegate === tabCoordinator)
        XCTAssert(tabCoordinator.childCoordinators.count == 1)
        XCTAssert(tabCoordinator.childCoordinators.first === mockCoordinator)
    }
}
