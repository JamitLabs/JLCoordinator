//
//  TabBarItemDataSource.swift
//  CoordinatorBase
//
//  Created by Jonathan Gräser on 02.07.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import UIKit

public protocol TabBarItemDelegate: AnyObject {
    func tabPresenter(_ presenter: TabPresenting, presentsViewController viewController: UIViewController, atTabBarIndex index: Int)
}
