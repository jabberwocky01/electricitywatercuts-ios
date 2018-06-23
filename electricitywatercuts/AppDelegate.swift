//
//  AppDelegate.swift
//  electricitywatercuts
//
//  Created by nils on 24.04.2018.
//  Copyright © 2018 nils. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    private let cutsUpdateHelper = CutsUpdateService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if !granted {
                // switch off notifications for new cuts
                //TODO: NilS
            } else {
                //TODO: NilS
                // self.scheduleNotification()
            }
        }
        
        // Override point for customization after application launch.
        // UIApplicationBackgroundFetchIntervalMinimum or in seconds
        UIApplication.shared.setMinimumBackgroundFetchInterval(1800)
                
        return true
    }
    
    //MARK: - Delegates
    /*
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let request = notification.request
        print ("request identifier: \(request.identifier)" )
        completionHandler([.alert,.badge,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let action = response.actionIdentifier
        let request = response.notification.request
        
        if action == "snooze.action"{
            let content = changeCutsNotification(content: request.content)
            
            let snoozeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
            let snoozeRequest = UNNotificationRequest(identifier: "pizza.snooze", content: changeCutsNotification(content:content), trigger: snoozeTrigger)
            center.add(snoozeRequest){
                (error) in
                if error != nil {
                    print("Snooze Request Error: \(error?.localizedDescription)")
                }
            }
        }
        completionHandler()
    }
    
    func changeCutsNotification(content oldContent:UNNotificationContent) -> UNMutableNotificationContent{
        //get a mutable copy of the content
        let content = oldContent.mutableCopy() as! UNMutableNotificationContent
        /*
        //get the dictionary
        let userInfo = content.userInfo as! [String:Any]
        //change the subtitle
        if userInfo["subtitle"] != nil{
            content.subtitle = userInfo["subtitle"] as! String
        }
         */
        
        /* TODO: NilS
        //change the body with the order
        if let orderEntry = userInfo["order"] {
            var body = ""
            let orders = orderEntry as! [String]
            for item in orders{
                body += item + "<img draggable="false" class="emoji>\n"
            }
            content.body = body
        }
         */
        // content.body = cutsUpdateHelper.prepareNotificationContent();
        let date = Date()
        let locale: Locale = Locale(identifier: "tr-TR")
        let formatter: DateFormatter = DateFormatter()
        let paramDateFormat = DateFormatter.dateFormat(fromTemplate: CutsConstants.yyyyMMdd, options: 0, locale: nil)
        formatter.locale = locale
        formatter.dateFormat = paramDateFormat
        let formattedDate = formatter.string(from: date)
        content.body = formattedDate
        return(content)
    }
    */
    
    // Support for background fetch
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // delete old data once in every month
        var date = Date()
        let locale: Locale = Locale(identifier: "tr-TR")
        let formatter: DateFormatter = DateFormatter()
        let paramDateFormat = DateFormatter.dateFormat(fromTemplate: CutsConstants.yyyyMMdd, options: 0, locale: nil)
        formatter.locale = locale
        formatter.dateFormat = paramDateFormat
        let today = formatter.string(from: date)
        let lastDeletionDate : String = UserDefaults.standard.string(forKey: CutsConstants.SETTING_DELETION_FREQ) ?? today
        if (today > lastDeletionDate) {
            CutsUpdateService().organizeCutsDB()
            date = NSCalendar.current.date(byAdding: .month, value: 1, to: date)!
            UserDefaults.standard.set(formatter.string(from: date), forKey: CutsConstants.SETTING_DELETION_FREQ)
        }
        
        // notification newly added cuts
        if (scheduleNotification()) {
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }
    
    func checkIfNotificationEnabled() -> Bool {
        var notificationEnabled : Bool = CutsHelper.localizedText(language: CutsHelper.getLocaleForApp(), key: "cuts_refresh_freq") != "-1"
        UNUserNotificationCenter.current().getNotificationSettings { (settings : UNNotificationSettings) in
            if settings.authorizationStatus == .authorized {
                // Still authorized
                notificationEnabled = notificationEnabled && true
            } else {
                // Not anymore
                notificationEnabled = notificationEnabled && false
            }
        }
        return notificationEnabled
    }
    
    func scheduleNotification() -> Bool {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        if (checkIfNotificationEnabled()) {
            let notificationContent = cutsUpdateHelper.prepareNotificationContent()
            if (!notificationContent.isEmpty) {
                let trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: 10.0, repeats: false) //close to immediate as we can get.
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "cuts_ticker", arguments: nil)
                content.subtitle = NSString.localizedUserNotificationString(forKey: "cuts_notify_text", arguments: nil)
                content.body = notificationContent
                content.categoryIdentifier = "notification"
                content.sound = UNNotificationSound.default()
                content.threadIdentifier = "cutsNotification"
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                return true
            }
        }
        return false
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

