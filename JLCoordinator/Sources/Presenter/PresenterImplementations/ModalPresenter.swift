import UIKit

open class ModalPresenter: ModalPresenting {
    public let observers: WeakCache<PresenterObserving> = .init()

    public let presentingViewController: UIViewController
    private let adaptivePresentationDelegateWrapper: AdaptivePresentationControllerDelegateWrapper = .init()
    private let modalPresentationConfiguration: ModalPresentationConfiguration

    public init(
        presentingViewController: UIViewController,
        configuration: ModalPresentationConfiguration = .default
    ) {
        assert(
            presentingViewController.presentedViewController == nil,
            "Trying to initialise ModalPresenter with a `UIViewController` which already is presenting another `UIViewController`. This is not allowed!"
        )

        self.presentingViewController = presentingViewController
        self.modalPresentationConfiguration = configuration
        adaptivePresentationDelegateWrapper.delegate = self
    }

    public func present(_ viewController: UIViewController, animated: Bool = true) {
        viewController.modalTransitionStyle = modalPresentationConfiguration.transitionStyle
        viewController.modalPresentationStyle = modalPresentationConfiguration.presentationStyle
        viewController.presentationController?.delegate = adaptivePresentationDelegateWrapper
        presentModally(viewController, animated: animated)
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = true) {
        dismissModally(viewController, animated: animated)
    }

    public func dismissRoot(animated: Bool) {
        let presentedViewController = presentingViewController.presentedViewController
        // If the presentedViewController is not nil the presentedViewController is dismissed.
        // If the presentedViewController is nil the presentingViewController is dismissed instead.
        // If the dimiss was triggered in a view which is presented by this
        // Presenter then the normal behaviour is that the presentedViewController is dismissed.
        presentingViewController.dismiss(animated: animated) { [weak self] in
            guard let presentedViewController = presentedViewController else { return }

            self?.notifyObserverAboutDismiss(of: presentedViewController)
        }
    }
}

extension ModalPresenter: AdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        modalPresentationConfiguration.presentationStyle
    }

    func adaptiveDidDismiss(_ viewController: UIViewController) {
        notifyObserverAboutDismiss(of: viewController)
    }
}
