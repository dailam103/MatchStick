//
//  AppDelegate.swift
//  Match-Que diêm
//
//  Created by NGUYỄN QUỐC ĐẠI LÂM on 2017/06/07.
//  Copyright © 2017 NGUYỄN QUỐC ĐẠI LÂM. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Add any custom logic here.
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        // Add any custom logic here.
        return handled
    }
    



//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance.application(application, didFinishLaunchingWithOptions: launchOptions as? [UIApplicationLaunchOptionsKey : Any] ?? [UIApplicationLaunchOptionsKey : Any]())
//    }


    func applicationWillResignActive(_ application: UIApplication) {
       // print("a1")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //print("a2")
        if let vc = window?.rootViewController as? ViewController {
            vc.app_out()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // print("a3")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
             //  print("a4")
        FBSDKAppEvents.activateApp()

        if let vc = window?.rootViewController as? ViewController {
            vc.app_in()
        }
        //add event facebook sdk
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
        //print("a5")
    }
    
}

