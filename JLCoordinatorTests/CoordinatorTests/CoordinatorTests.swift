import JLCoordinator
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

        let stopExpectation = expectation(description: "Did stop child")
        coordinator.didStopAction = { stoppedCoordinator in
            XCTAssertTrue(stoppedCoordinator === childCoordinator)
            stopExpectation.fulfill()
        }

        coordinator.add(childCoordinator: childCoordinator)
        childCoordinator.start()
        childCoordinator.stop()

        XCTAssertNil(childCoordinator.parentCoordinator)
        XCTAssertNil(coordinator.childCoordinators.first { $0 === childCoordinator })
        wait(for: [stopExpectation], timeout: 1)
    }

    func testRemoveFunctionOfChildCoordinator() throws {
        let coordinator = MockCoordinator(presenter: InitialPresenter(window: UIWindow()))
        coordinator.start()

        let childCoordinator = MockCoordinator(presenter: InitialPresenter(window: UIWindow()))

        let removedExpectation = expectation(description: "Did remove child")
        coordinator.didRemoveAction = { removedCoordinator in
            XCTAssertTrue(removedCoordinator === childCoordinator)
            removedExpectation.fulfill()
        }

        coordinator.add(childCoordinator: childCoordinator)
        childCoordinator.start()
        childCoordinator.removeFromParentCoordinator()

        XCTAssertNil(childCoordinator.parentCoordinator)
        XCTAssertNil(coordinator.childCoordinators.first { $0 === childCoordinator })
        wait(for: [removedExpectation], timeout: 1)
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

    func testPresenterDidDismissFunctionCall() throws {
        let initialPresenter = InitialPresenter(window: UIWindow())
        let coordinator = MockCoordinator(presenter: initialPresenter)
        let viewControllerToDismiss: UIViewController = .init()

        let waitExpectation = expectation(description: "Wait until dismiss action called")
        coordinator.didDismissAction = { presenter, viewController in
            XCTAssertTrue(initialPresenter === presenter)
            XCTAssertTrue(viewControllerToDismiss === viewController)
            waitExpectation.fulfill()
        }

        initialPresenter.notifyObserverAboutDismiss(of: viewControllerToDismiss)
        wait(for: [waitExpectation], timeout: 1)
    }

    func testPresenterDidPresentFunctionCall() throws {
        let initialPresenter = InitialPresenter(window: UIWindow())
        let coordinator = MockCoordinator(presenter: initialPresenter)
        let viewControllerToPresent: UIViewController = .init()

        let waitExpectation = expectation(description: "Wait until dismiss action called")
        coordinator.didPresentAction = { presenter, viewController in
            XCTAssertTrue(initialPresenter === presenter)
            XCTAssertTrue(viewControllerToPresent === viewController)
            waitExpectation.fulfill()
        }

        initialPresenter.notifyObserverAboutPresentation(of: viewControllerToPresent)
        wait(for: [waitExpectation], timeout: 1)
    }

    func testPresenterDidDismissNavigationControllerFunctionCall() throws {
        let initialPresenter = InitialPresenter(window: UIWindow())
        let coordinator = MockCoordinator(presenter: initialPresenter)
        let navigationControllerToDismiss: UINavigationController = .init()

        let waitExpectation = expectation(description: "Wait until dismiss action called")
        coordinator.didDismissNavigationController = { presenter, navigationController in
            XCTAssertTrue(initialPresenter === presenter)
            XCTAssertTrue(navigationControllerToDismiss === navigationController)
            waitExpectation.fulfill()
        }

        initialPresenter.notifyObserverAboutDismiss(of: navigationControllerToDismiss)
        wait(for: [waitExpectation], timeout: 1)
    }

    func testPresenterDidDismissAllViewControllerButRootFunctionCall() throws {
        let initialPresenter = InitialPresenter(window: UIWindow())
        let coordinator = MockCoordinator(presenter: initialPresenter)
        let navigationControllerToPresent: UINavigationController = .init()
        let rootViewControllerToPresent: UIViewController = .init()

        let waitExpectation = expectation(description: "Wait until dismiss action called")
        coordinator.didDismissAllViewControllerToRoot = { presenter, navigationController, rootViewController in
            XCTAssertTrue(initialPresenter === presenter)
            XCTAssertTrue(rootViewControllerToPresent === rootViewController)
            XCTAssertTrue(navigationControllerToPresent === navigationController)
            waitExpectation.fulfill()
        }

        initialPresenter.notifyObserverAboutDismissOfAllViewControllers(but: rootViewControllerToPresent, of: navigationControllerToPresent)
        wait(for: [waitExpectation], timeout: 1)
    }

    func testAddCoordinatorAsChildWhichAlreadyHasParent() throws {
        let firstParentCoordinator: MockCoordinator = .init(presenter: InitialPresenter(window: .init()))
        let secondParentCoordinator: MockCoordinator = .init(presenter: InitialPresenter(window: .init()))
        let childCoordinator: MockCoordinator = .init(presenter: InitialPresenter(window: .init()))

        firstParentCoordinator.add(childCoordinator: childCoordinator);
        secondParentCoordinator.add(childCoordinator: childCoordinator);
        XCTAssertTrue(firstParentCoordinator === childCoordinator.parentCoordinator)
        XCTAssertFalse(secondParentCoordinator.childCoordinators.contains(where: { $0 === childCoordinator }))
        XCTAssertTrue(firstParentCoordinator.childCoordinators.contains(where: { $0 === childCoordinator }))
    }

    func testChangeParentCoordinator() throws {
        let firstParentCoordinator: MockCoordinator = .init(presenter: InitialPresenter(window: .init()))
        let secondParentCoordinator: MockCoordinator = .init(presenter: InitialPresenter(window: .init()))
        let childCoordinator: MockCoordinator = .init(presenter: InitialPresenter(window: .init()))

        firstParentCoordinator.add(childCoordinator: childCoordinator);
        XCTAssertTrue(firstParentCoordinator === childCoordinator.parentCoordinator)
        childCoordinator.removeFromParentCoordinator()
        XCTAssertNil(childCoordinator.parentCoordinator)

        secondParentCoordinator.add(childCoordinator: childCoordinator);
        XCTAssertTrue(secondParentCoordinator === childCoordinator.parentCoordinator)
        XCTAssertFalse(firstParentCoordinator.childCoordinators.contains(where: { $0 === childCoordinator }))
        XCTAssertTrue(secondParentCoordinator.childCoordinators.contains(where: { $0 === childCoordinator }))
    }
}
