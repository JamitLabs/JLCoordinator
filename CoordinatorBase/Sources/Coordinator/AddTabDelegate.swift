//
//  AddTabDelegate.swift
//  CoordinatorBase
//
//  Created by Jonathan Gräser on 02.07.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import UIKit

public protocol AddTabDelegate: AnyObject {
    func addTab(for coordinator: (UITabBarController) -> Coordinator)
}
