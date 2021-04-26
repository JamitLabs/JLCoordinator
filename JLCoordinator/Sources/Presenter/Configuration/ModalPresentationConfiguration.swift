//  Copyright © 2021 Jamit Labs. All rights reserved.

import UIKit

/// Configuration to use with `ModalPresenter` or `ModalNavigationPresenter`.
public struct ModalPresentationConfiguration {
    private static var defaultPresentationStyle: UIModalPresentationStyle {
        if #available(iOS 13.0, *) {
            return .automatic
        } else {
            return .fullScreen
        }
    }

    /// The transition style to use.
    public let transitionStyle: UIModalTransitionStyle
    /// The presentation style to use.
    public let presentationStyle: UIModalPresentationStyle

    /**
     * The initializer for the configuration to use with `ModalPresenter` or `ModalNavigationPresenter`.
     *
     * - Parameter transitionStyle: The transition style to use. Default value is `coverVertical`
     * - Parameter presentationStyle: The presentation style to use. Default value is `automatic` for iOS 13.0 and upwards and `fullscreen` below.
     */
    public init(
        transitionStyle: UIModalTransitionStyle = Self.default.transitionStyle,
        presentationStyle: UIModalPresentationStyle = Self.default.presentationStyle
    ) {
        self.transitionStyle = transitionStyle
        self.presentationStyle = presentationStyle
    }
}

extension ModalPresentationConfiguration {
    public static let `default`: Self = .init(
        transitionStyle: .coverVertical,
        presentationStyle: defaultPresentationStyle
    )
}
