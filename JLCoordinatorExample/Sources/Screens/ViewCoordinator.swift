import JLCoordinator
import UIKit

final class ViewCoordinator: Coordinator, CoordinatorObserving {
    private let viewController: ViewController = UIStoryboard(name: "ViewController", bundle: nil)
        .instantiateViewController(identifier: "ViewController")

    override init(presenter: Presenter) {
        super.init(presenter: presenter)

        // NOTE: This is just used to supervise the number of coordinatores and the allocation and deallocation of them.
        CoordinatorCounter.shared.register(self)
    }

    override func start() {
        viewController.delegate = self
        presenter.present(viewController, animated: true)
    }

    override func presenter(_ presenter: Presenter, didDismiss viewController: UIViewController) {
        guard
            viewController === self.viewController ||
            self.viewController.tabBarController === viewController
        else {
            return
        }

        stop()
    }

    override func presenter(_ presenter: Presenter, didDismiss navigationController: UINavigationController) {
        stop()
    }

    override func presenter(
        _ presenter: Presenter,
        didDismissAllViewControllersTo rootViewController: UIViewController,
        of navigationController: UINavigationController
    ) {
        if viewController === rootViewController {
            childCoordinators.forEach { $0.stop() }
        }
    }

    func coordinatorCounter(_ counter: CoordinatorCounter, changedCountTo count: Int) {
        viewController.coordinatorCount = count
    }

    deinit {
        CoordinatorCounter.shared.unregister(self)
    }
}

extension ViewCoordinator: ViewControllerDelegate {
    func didTriggerModalViewController(in viewController: ViewController) {
        let viewCoordinator = ViewCoordinator(presenter: ModalPresenter(presentingViewController: viewController))
        add(childCoordinator: viewCoordinator)
        viewCoordinator.start()
    }

    func didTriggerFullscreenModalViewController(in viewController: ViewController) {
        let viewCoordinator = ViewCoordinator(
            presenter: ModalPresenter(
                presentingViewController: viewController,
                configuration: .init(
                    transitionStyle: .coverVertical,
                    presentationStyle: .fullScreen
                )
            )
        )
        add(childCoordinator: viewCoordinator)
        viewCoordinator.start()
    }

    func didTriggerModalNavigationController(in viewController: ViewController) {
        let viewCoordinator: ViewCoordinator = .init(
            presenter: ModalNavigationPresenter(presentingViewController: viewController)
        )
        add(childCoordinator: viewCoordinator)
        viewCoordinator.start()
    }

    func didTriggerFullscreenModalNavigationViewController(in viewController: ViewController) {
        let viewCoordinator: ViewCoordinator = .init(
            presenter: ModalNavigationPresenter(
                presentingViewController: viewController,
                configuration: .init(
                    transitionStyle: .coverVertical,
                    presentationStyle: .fullScreen
                )
            )
        )
        add(childCoordinator: viewCoordinator)
        viewCoordinator.start()
    }

    func didTriggerPushViewController(in viewController: ViewController) {
        let viewCoordinator: ViewCoordinator
        switch presenter {
        case is NavigablePresenting:
            viewCoordinator = .init(presenter: presenter)

        default:
            viewCoordinator = .init(presenter: ModalNavigationPresenter(presentingViewController: viewController))
        }

        add(childCoordinator: viewCoordinator)
        viewCoordinator.start()
    }

    func didTriggerModalTabController(in viewController: ViewController) {
        let tabCoordinator: TabCoordinator = .init(presenter: ModalPresenter(presentingViewController: viewController))
        add(childCoordinator: tabCoordinator)
        tabCoordinator.start()
    }

    func didTriggerModalTabNavigationController(in viewController: ViewController) {
        let tabCoordinator: TabCoordinator = .init(presenter: ModalPresenter(presentingViewController: viewController))
        add(childCoordinator: tabCoordinator)
        tabCoordinator.start()
    }

    func didTriggerCloseButton(in viewController: ViewController) {
        presenter.dismiss(viewController, animated: true)
    }

    func didTriggerCloseRootButton(in viewController: ViewController) {
        presenter.dismissRoot(animated: true)
    }
}
