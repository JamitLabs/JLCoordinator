import XCTest
import JLCoordinator
@testable import JLCoordinatorExample

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
        viewCoordinator.start()
        viewCoordinator.didTriggerModalViewController(in: .init())
        XCTAssert(viewCoordinator.childCoordinators.count == 1)
    }

    func testDidTriggerModalNavigationController() {
        let mockPresenter: MockPresenter = .init()
        let viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.start()
        viewCoordinator.didTriggerModalNavigationController(in: .init())
        XCTAssert(viewCoordinator.childCoordinators.count == 1)
    }

    func testDidTriggerPushViewController() {
        let mockPresenter: MockPresenter = .init()
        let viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.start()
        viewCoordinator.didTriggerPushViewController(in: .init())
        XCTAssert(viewCoordinator.childCoordinators.count == 1)
    }

    func testDidTriggerModalTabController() {
        let mockPresenter: MockPresenter = .init()
        let viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.start()
        viewCoordinator.didTriggerModalTabController(in: .init())
        XCTAssert(viewCoordinator.childCoordinators.count == 1)
    }

    func testDidTriggerModalTabNavigationController() {
        let mockPresenter: MockPresenter = .init()
        let viewCoordinator: ViewCoordinator = .init(presenter: mockPresenter)
        viewCoordinator.start()
        viewCoordinator.didTriggerModalTabNavigationController(in: .init())
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
