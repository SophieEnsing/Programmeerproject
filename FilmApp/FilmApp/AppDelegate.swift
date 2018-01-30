//
//  AppDelegate.swift
//  FilmApp
//
//  Created by Sophie Ensing on 11-01-18.
//  Copyright © 2018 Sophie Ensing. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
        -> Bool {
            FirebaseApp.configure()
            UINavigationBar.appearance().barStyle = .blackOpaque
            UIApplication.shared.statusBarStyle = .lightContent
            return true
    }

}
