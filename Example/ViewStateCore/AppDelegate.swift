//
//  AppDelegate.swift
//  ViewStateCore
//
//  Created by congncif on 01/17/2018.
//  Copyright (c) 2018 congncif. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var state = TestState()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let obj1 = NSObject()
        let obj2 = NSObject()
        
        print(String(describing: obj1))
        print(String(describing: obj2))
        
        return true
    }

}

