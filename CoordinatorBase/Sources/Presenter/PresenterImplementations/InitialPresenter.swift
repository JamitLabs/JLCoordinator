// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public class InitialPresenter: Presenter {
    public let observers: WeakCache<PresenterObserving> = .init()

    public let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = false) {
        window.isHidden = true
    }

    public func present(_ viewController: UIViewController, animated: Bool = false) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
