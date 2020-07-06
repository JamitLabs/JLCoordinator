// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public protocol AddTabDelegate: AnyObject {
    func addTab(for coordinator: (UITabBarController) -> Coordinator)
}
