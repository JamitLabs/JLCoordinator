// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

// swiftlint:disable too_much_indentation
/// `AdaptivePresentationControllerDelegate` is the delegate which gets informed from the
/// `AdaptivePresentingControllerDelegateWrapper`
protocol AdaptivePresentationControllerDelegate: AnyObject {
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
}
