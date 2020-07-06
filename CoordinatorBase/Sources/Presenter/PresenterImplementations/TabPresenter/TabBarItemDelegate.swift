// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public protocol TabBarItemDelegate: AnyObject {
    func tabPresenter(_ presenter: TabPresenting, presentsViewController viewController: UIViewController, atTabBarIndex index: Int)
}
