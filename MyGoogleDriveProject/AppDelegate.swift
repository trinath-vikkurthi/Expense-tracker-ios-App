//
//  AppDelegate.swift
//  MyGoogleDriveProject
//
//  Created by Nguyen Uy on 15/2/19.
//  Copyright © 2019 Nguyen Uy. All rights reserved.
//
//88995D
import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = "367745865997-4n8islo70c77apgm7vbo3169squqv26e.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
             GIDSignIn.sharedInstance().uiDelegate = self
             GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
             GIDSignIn.sharedInstance()?.signInSilently()
           
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
extension AppDelegate:  GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            let rootViewController = self.window!.rootViewController as! UINavigationController
             let vc : ViewController2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
            vc.b = false
             rootViewController.pushViewController(vc, animated: true)

        } else {
            print("Authenticate successfully App Deligate")
           let rootViewController = self.window!.rootViewController as! UINavigationController
             let mainVc : ViewController2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
            mainVc.b = true
            rootViewController.viewControllers = [mainVc]
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Did disconnect to user")
    }
}

extension AppDelegate: GIDSignInUIDelegate {}
