//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Tatsuya Tanaka on 2017/02/12.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit
import Replacer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        replaceInstance(#selector(UIViewController.viewWillAppear(_:)),
                                 of: UIViewController.self,
                                 with: #selector(UIViewController.orig_viewWillAppear(_:)),
                                 of: UIViewController.self)

        return true
    }
}

extension UIViewController {
    func orig_viewWillAppear(_ animated: Bool) {
        orig_viewWillAppear(animated)

        print("swizzled")
    }
}

