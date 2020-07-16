// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import CoordinatorBase
import UIKit

final class ViewCoordinator: Coordinator, CoordinatorObserving {
    private let viewController: ViewController = UIStoryboard(name: "ViewController", bundle: nil).instantiateViewController(identifier: "ViewController")

    override init(presenter: Presenter) {
        super.init(presenter: presenter)

        CoordinatorCounter.shared.register(self)
    }

    deinit {
        CoordinatorCounter.shared.unregister(self)
    }

    override func start() {
        viewController.delegate = self
        presenter.present(viewController, animated: true)
    }

    override func presenter(_ presenter: Presenter, didDismiss viewController: UIViewController) {
        guard viewController === self.viewController else { return }

        stop()
    }

    override func presenter(_ presenter: Presenter, didDismiss navigationController: UINavigationController) {
        guard navigationController === viewController.navigationController else { return }

        stop()
    }

    func coordinatorCounter(_ counter: CoordinatorCounter, changedCountTo count: Int) {
        viewController.coordinatorCount = count
    }
}

extension ViewCoordinator: ViewControllerDelegate {
    func didTriggerModalViewController(in viewController: ViewController) {
        let viewCoordinator = ViewCoordinator(presenter: ModalPresenter(presentingViewController: viewController))
        add(childCoordinator: viewCoordinator)
        viewCoordinator.start()
    }

    func didTriggerModalNavigationController(in viewController: ViewController) {
        let viewCoordinator: ViewCoordinator = .init(presenter: ModalNavigationPresenter(presentingViewController: viewController))
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
