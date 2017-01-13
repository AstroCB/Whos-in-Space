//
//  AppDelegate.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 7/16/14.
//  Copyright (c) 2014 Cameron Bernhardt. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Register for Push Notifications
        if #available(iOS 10.0, *) {
            let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert], completionHandler: { (granted: Bool, err: Error?) in
                if granted {
                    print("Successful push authorization")
                } else {
                    print("Push authorization denied")
                }
                
                if let error: Error = err {
                    print("Error: \(error)")
                }
            })
            application.registerForRemoteNotifications()
        } else if #available(iOS 8.0, *) {
            let notificationTypes: UIUserNotificationType = ([.alert, .badge, .sound])
            let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        } else {
            // Fallback on earlier versions
            application.registerForRemoteNotifications(matching: [.alert, .badge, .sound])
        }
        return true
    }
    
    // MARK: - Push notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString: String = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        self.sendTokenToServer(token: deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed (likely due to Simulator): \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let aps: [String: String] = userInfo[AnyHashable("aps")] as? [String: String], let body: String = aps["alert"], let win: UIWindow = self.window, let controller: UIViewController = win.rootViewController {
            alert("Alert", message: body, controller: controller)
        } else {
            print("Error alerting user while in-app")
            print(userInfo)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func sendTokenToServer(token: String) {
        var request: URLRequest = URLRequest(url: URL(string: "https://astrocb-push.herokuapp.com/newtoken")!)
        request.httpMethod = "POST"
        let bundleId: String = Bundle.main.bundleIdentifier! // Should never be null
        let postString: String = "token=\(token)&bundleId=\(bundleId)"
        request.httpBody = postString.data(using: .utf8)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // Check for fundamental networking error
                print("Error: \(error)")
                return
            }
            
            if let httpStatus: HTTPURLResponse = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // Check for HTTP errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("Response: \(response)")
            }
            
            let responseString: String? = String(data: data, encoding: .utf8)
            print("responseString: \(responseString)")
        }
        task.resume()
    }

}

