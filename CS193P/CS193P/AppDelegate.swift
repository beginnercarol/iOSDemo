//
//  AppDelegate.swift
//  CS193P
//
//  Created by Carol on 2019/1/9.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var tabBarController: UITabBarController!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let playingCardVC = PlayingCardViewController()
        playingCardVC.tabBarItem = UITabBarItem(title: "PlayingCard", image: nil, selectedImage: nil)
        let scrollVC = ScrollViewController()
        scrollVC.tabBarItem = UITabBarItem(title: "Scroll", image: nil, selectedImage: nil)
        let splitVC = PlanetSplitViewController()
        splitVC.tabBarItem = UITabBarItem(title: "Split", image: nil, selectedImage: nil)
        
        let emojiVC = EmojiArtViewController()
        emojiVC.tabBarItem = UITabBarItem(title: "Emoji", image: nil, selectedImage: nil)
        let navigationVC = UINavigationController(rootViewController: emojiVC)
        navigationVC.tabBarItem = UITabBarItem(title: "Emoji", image: nil, selectedImage: nil)
        let documentVC = DocumentBrowserViewController()
        documentVC.tabBarItem = UITabBarItem(title: "Emoji", image: nil, selectedImage: nil)
        let imageGalleryVC = ImageGalleryViewController()
        imageGalleryVC.tabBarItem = UITabBarItem(title: "ImageGallery", image: nil, selectedImage: nil)
        let stackGalleryVC = ScrollStackViewController()
        stackGalleryVC.tabBarItem = UITabBarItem(title: "Stack", image: nil, selectedImage: nil)
        tabBarController = UITabBarController()
        tabBarController.viewControllers = [stackGalleryVC, documentVC]
        tabBarController.tabBar.isTranslucent = false
        window?.backgroundColor = UIColor.gray
        window?.rootViewController = tabBarController
        window?.backgroundColor = UIColor.black
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

