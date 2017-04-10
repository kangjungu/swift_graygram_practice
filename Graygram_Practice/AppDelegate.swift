//
//  AppDelegate.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 6..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import UIKit

import CGFloatLiteral
import Kingfisher
import ManualLayout
import SnapKit
import Then

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // `AppDelegate`의 인스턴스를 반환합니다.
    static var instance:AppDelegate?{
        return UIApplication.shared.delegate as? AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.configureAppearance()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        let splashViewController = SplashViewController()
        let navigationController = UINavigationController(rootViewController: splashViewController)
        window.rootViewController = navigationController
        
        self.window = window
        return true
    }

    func configureAppearance(){
        UINavigationBar.appearance().tintColor = .black
        UIBarButtonItem.appearance().tintColor = .black
        UITabBar.appearance().tintColor = .black
    }
    
    func presentLoginScreen(){
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        self.window?.rootViewController = navigationController
    }
    
    func presentMainScreen(){
        let tabBarController = MainTabBarController()
        self.window?.rootViewController = tabBarController
    }

}

