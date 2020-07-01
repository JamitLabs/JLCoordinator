//
//  AppDelegate.swift
//  CoordinatorBaseExample
//
//  Created by Jens on 12.06.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import CoordinatorBase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var mainCoordinator: MainCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window: UIWindow = .init()
        mainCoordinator = .init(presenter: InitialPresenter(window: window))
        mainCoordinator?.start()
        return true
    }
}
