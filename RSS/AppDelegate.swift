//
//  AppDelegate.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/21/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Firebase
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.black
        self.window?.makeKeyAndVisible()
        
        //Google places api
        GMSPlacesClient.provideAPIKey(Global.mapKey)
        
        // keyboard
        let keyboardManager = IQKeyboardManager.shared()
        keyboardManager.isEnabled = true
        keyboardManager.previousNextDisplayMode = .alwaysShow
        keyboardManager.shouldShowTextFieldPlaceholder = false
        
        //Firebase
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        
        if UserDefaultManager.getInstance().getHasRunBefore() == false {
            UserDefaultManager.getInstance().setHasRunBefore(value: true)
            if FIRAuth.auth()?.currentUser != nil {
                do {
                    FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/" + (FIRAuth.auth()?.currentUser?.uid)!)
                    try FIRAuth.auth()?.signOut()
                    self.window?.rootViewController = SplashScreenViewController()
                }
                catch _ as NSError {
                    
                    self.window?.rootViewController = SplashScreenViewController()
                }
            }
            else {
                self.window?.rootViewController = SplashScreenViewController()
            }
        }
        else {
            self.window?.rootViewController = SplashScreenViewController()
        }
        
        
        //change orientation
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        //Push notification
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self as? FIRMessagingDelegate
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: .firInstanceIDTokenRefresh, object: nil)
        
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type:FIRInstanceIDAPNSTokenType.prod)
        print("APNs token retrieved: \(deviceToken.base64EncodedString())")
    }
    
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    var isInit = false
    func rotated() {
        if isInit {
            return
        }
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            Global.SCREEN_WIDTH = UIScreen.main.bounds.size.height
            Global.SCREEN_HEIGHT = UIScreen.main.bounds.size.width
            isInit = true
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            Global.SCREEN_WIDTH = UIScreen.main.bounds.size.width
            Global.SCREEN_HEIGHT = UIScreen.main.bounds.size.height
            isInit = true
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        FIRMessaging.messaging().disconnect()
//        print("Disconnected from FCM.")
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    
    
    // Receive displayed notifications for iOS 10 devices.
//    @available(iOS 10.0, *)
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        
//        Utils.setBadgeIndicator(badgeCount: 10)
//
//        // Print full message.
//        print(userInfo)
//        
////        Utils.setBadgeIndicator(badgeCount: 2)
//        
//        // Change this to your preferred presentation option
//        completionHandler([])
//    }
//    
//    @available(iOS 10.0, *)
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        
//        Utils.setBadgeIndicator(badgeCount: 11)
//
//        
//        // Print full message.
//        print(userInfo)
//        
////        Utils.setBadgeIndicator(badgeCount: 3)
//        
//        completionHandler()
//    }
}
