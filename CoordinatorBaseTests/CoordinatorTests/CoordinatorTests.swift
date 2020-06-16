//
//  CoordinatorTests.swift
//  CoordinatorBaseTests
//
//  Created by Jens on 15.06.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import CoordinatorBase
import XCTest

class CoordinatorTests: XCTestCase {
    func testStartFunction() throws {
        let coordinator = MockCoordinator(presenter: InitialPresenter(window: UIWindow()))

        let didStartExpectation = XCTestExpectation(description: "Did call start")
        coordinator.startAction = {
            didStartExpectation.fulfill()
        }
        coordinator.start()

        wait(for: [didStartExpectation], timeout: 1.0)
    }

    func testStopFunction() throws {
        let parentCoordinator = MockCoordinator(presenter: InitialPresenter(window: UIWindow()))
        let coordinator = MockCoordinator(presenter: InitialPresenter(window: UIWindow()))
        let childCoordinator = MockCoordinator(presenter: InitialPresenter(window: UIWindow()))

        // Add coordinator to parent and start
        parentCoordinator.add(childCoordinator: coordinator)
        parentCoordinator.start()

        // Add a child coordinator and start it
        coordinator.add(childCoordinator: childCoordinator)
        childCoordinator.start()

        let didStopExpectation = XCTestExpectation(description: "Did call did stop child")
        parentCoordinator.didStopAction = { child in
            XCTAssertTrue(child === coordinator)
            didStopExpectation.fulfill()
        }

        let didStopChildrenExpectation = XCTestExpectation(description: "Did call did stop children")
        coordinator.didStopAction = { child in
            XCTAssertTrue(child === childCoordinator)
            didStopChildrenExpectation.fulfill()
        }

        coordinator.stop()

        wait(for: [didStopChildrenExpectation, didStopExpectation], timeout: 1.0)
        XCTAssertTrue(coordinator.childCoordinators.isEmpty)
        XCTAssertNil(coordinator.parentCoordinator)
        XCTAssertTrue(parentCoordinator.childCoordinators.isEmpty)
    }

    func testAddingChildCoordinator() throws {
        let coordinator = MockCoordinator(presenter: InitialPresenter(window: UIWindow()))
        coordinator.start()

        let childCoordinator = MockCoordinator(presenter: InitialPresenter(window: UIWindow()))
        coordinator.add(childCoordinator: childCoordinator)
        childCoordinator.start()

        XCTAssertEqual(coordinator.childCoordinators.count, 1)
        XCTAssertTrue(coordinator.childCoordinators.contains { child in child === childCoordinator })
        XCTAssertTrue(childCoordinator.parentCoordinator === coordinator)
    }

    func testAddingChildCoordinatorDuplicate() throws {
        let coordinator = MockCoordinator(presenter: InitialPresenter(window: UIWindow()))
        coordinator.start()

        let childCoordinator = MockCoordinator(presenter: InitialPresenter(window: UIWindow()))
        coordinator.add(childCoordinator: childCoordinator)
        childCoordinator.start()

        // Try to add the child twice!
        coordinator.add(childCoordinator: childCoordinator)

        XCTAssertEqual(coordinator.childCoordinators.count, 1)
        XCTAssertTrue(coordinator.childCoordinators.contains { child in child === childCoordinator })
        XCTAssertTrue(childCoordinator.parentCoordinator === coordinator)
    }

    func testStopFunctionOfChildCoordinator() throws {
        let coordinator = MockCoordinator(presenter: InitialPresenter(window: UIWindow()))
        coordinator.start()

        let childCoordinator = MockCoordinator(presenter: InitialPresenter(window: UIWindow()))
        coordinator.add(childCoordinator: childCoordinator)
        childCoordinator.start()
        childCoordinator.stop()

        XCTAssertNil(childCoordinator.parentCoordinator)
        XCTAssertNil(coordinator.childCoordinators.first { $0 === childCoordinator })
    }

    func testReplacingPresenter() throws {
        let initialPresenter = InitialPresenter(window: UIWindow())
        let coordinator = MockCoordinator(presenter: initialPresenter)
        XCTAssertTrue(initialPresenter.observers.contains(coordinator))

        let alternativePresenter = ModalPresenter(presentingViewController: UIViewController())
        coordinator.presenter = alternativePresenter
        XCTAssertFalse(initialPresenter.observers.contains(coordinator))
        XCTAssertTrue(alternativePresenter.observers.contains(coordinator))
    }
}
