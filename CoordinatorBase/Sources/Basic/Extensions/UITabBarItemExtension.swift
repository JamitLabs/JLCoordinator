//
//  UITabBarItemExtension.swift
//  CoordinatorBaseExample
//
//  Created by Jonathan Gräser on 01.07.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import UIKit

extension UITabBarItem {
    func editWithContentsOfItem(_ item: UITabBarItem) {
        title = item.title
        image = item.image
        selectedImage = item.selectedImage
    }
}
