// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

protocol AdaptivePresentationControllerDelegate: AnyObject {
    func adaptiveDidDismiss(_ viewController: UIViewController)
}

final class AdaptivePresentationControllerDelegateWrapper: NSObject, UIAdaptivePresentationControllerDelegate {
    weak var delegate: AdaptivePresentationControllerDelegate?

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.adaptiveDidDismiss(presentationController.presentedViewController)
    }
}
