// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

class InitialPresenter: Presenter {
    let observers: WeakCache<PresenterObserving> = .init()

    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func dismiss(_ viewController: UIViewController, animated: Bool = false) {
        window.isHidden = true
    }

    func present(_ viewController: UIViewController, animated: Bool = false) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
