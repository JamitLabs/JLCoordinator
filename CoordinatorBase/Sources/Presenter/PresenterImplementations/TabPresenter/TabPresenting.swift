// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

protocol TabPresenting: AnyObject {
    var tabBarController: UITabBarController { get }

    init(tabBarController: UITabBarController)
}
