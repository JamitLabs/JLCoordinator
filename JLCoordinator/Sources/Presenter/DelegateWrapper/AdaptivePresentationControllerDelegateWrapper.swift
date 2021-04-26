import UIKit

// swiftlint:disable too_much_indentation too_much_unindentation
/// `AdaptivePresentationControllerDelegate` is the delegate which gets informed from the
/// `AdaptivePresentingControllerDelegateWrapper`
protocol AdaptivePresentationControllerDelegate: AnyObject {
    /**
     * Asks the delegate for the new presentation style to use.
     *
     * - Parameter controller: The presentation controller that is managing the size change.
     *                         Use this object to retrieve the view controllers involved in the presentation.
     */
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle

    // swiftlint:enable too_much_indentation
    /// This function is called, if a modally presented `UIViewController` has been dismissed adaptive
    ///
    /// - parameter viewController: The dismissed `UIViewController`
    func adaptiveDidDismiss(_ viewController: UIViewController)
}

/// AdaptivePresentingControllerDelegateWrapper is wrapping the `UIAdaptivePresentationControllerDelegate` to avoid the
/// need of subclassing `NSObject`
final class AdaptivePresentationControllerDelegateWrapper: NSObject, UIAdaptivePresentationControllerDelegate {
    /// The `object` which gets informed about calls of the `UIAdaptivePresentationControllerDelegate`
    weak var delegate: AdaptivePresentationControllerDelegate?

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.adaptiveDidDismiss(presentationController.presentedViewController)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        guard let delegate = delegate else {
            return ModalPresentationConfiguration.default.presentationStyle
        }

        return delegate.adaptivePresentationStyle(for: controller)
    }
}
