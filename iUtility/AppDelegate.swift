//
//  AppDelegate.swift
//  iUtility
//
//  Created by Dani Tox on 28/12/16.
//  Copyright © 2016 Dani Tox. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseDatabase
import UserNotifications
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var ref: FIRDatabaseReference!
    var handle:FIRDatabaseHandle!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        
        
        
        
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc : UIViewController
        
        if UserDefaults.standard.string(forKey: "OnboardingEffettuato") == nil {
            vc = storyboard.instantiateViewController(withIdentifier: "onboarding")
            
        }
        else {
            vc = storyboard.instantiateInitialViewController()!
            
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
                
                
                // For iOS 10 data message (sent via FCM)
                //                FIRMessaging.messaging().remoteMessageDelegate = self
                
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            
            application.registerForRemoteNotifications()
            
//            let notificationTypes : UIUserNotificationType = [.alert, .badge, .sound]
//            let notificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
//            application.registerForRemoteNotifications()
//            application.registerUserNotificationSettings(notificationSettings)
            
        }
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        FIRApp.configure()
        
        if let username = UserDefaults.standard.string(forKey: "usernameAccount") {
            if username != "" {
                let date = Date()
                let now = Calendar.current
                let hour = now.component(.hour, from: date)
                let minute = now.component(.minute, from: date)
                let day = now.component(.day, from: date)
                let month = now.component(.month, from: date)
                let year = now.component(.year, from: date)
                
                ref = FIRDatabase.database().reference()
                ref.child("Utenti").child(username).child("Ultimo Accesso").setValue("\(hour):\(minute) - \(day)/\(month)/\(year)")
            }
        }
        
        
        
        
        
        return true
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler(
            [UNNotificationPresentationOptions.alert,
             UNNotificationPresentationOptions.sound,
             UNNotificationPresentationOptions.badge])
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
        
        if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
                
                // For iOS 10 data message (sent via FCM)
                //                FIRMessaging.messaging().remoteMessageDelegate = self
                
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            
            application.registerForRemoteNotifications()
        
        UIApplication.shared.applicationIconBadgeNumber = 0

        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        print("MessageID : \(String(describing: userInfo["gmc_message_id"]))!")
        
        //if application.applicationState == UIApplicationState.active {
        DispatchQueue.main.async {
            let importantAlert: UIAlertController = UIAlertController(title: "Action Sheet", message: "Hello I was presented from appdelegate ;)", preferredStyle: .actionSheet)
            self.window?.rootViewController?.present(importantAlert, animated: true, completion: nil)
            }
        
        
        //}
        
    }
    
    

}

