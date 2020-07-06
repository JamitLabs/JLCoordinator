// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

extension UITabBarItem {
    func editWithContentsOfItem(_ item: UITabBarItem) {
        title = item.title
        image = item.image
        selectedImage = item.selectedImage
    }
}
