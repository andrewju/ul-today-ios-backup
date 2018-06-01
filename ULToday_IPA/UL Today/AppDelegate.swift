//
//  AppDelegate.swift
//  UL Timetable
//
//  Created by Andrew on 16/8/8.
//  Copyright © 2016年 Andrew Design. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var systemVersion: Int = 0
    var serverResponse: Int?
    var serverVersion: Int?
    
    var swipeGestureLeft  = UISwipeGestureRecognizer()
    var swipeGestureRight  = UISwipeGestureRecognizer()
    
    var remoteConfig: ULConfiguration?
    var mainVc: MainViewController?
    
    class func getRemoteConfig() -> ULConfiguration? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.remoteConfig
        }
        return nil
    }
    
    func request(requestURL: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let data = data, let _:URLResponse = response, error == nil else {
                completion(nil, response, error)
                return
            }
            completion(data, response, error)
        }
        
        task.resume()
    }
    
    func requestControl() {
        guard let remoteConfig = self.remoteConfig else {
            return
        }
        self.request(requestURL: URL.init(string: "\(remoteConfig.serverHost)/\(remoteConfig.getServiceName(ULRemoteConfigurationKey.serviceControl.rawValue, defaultValue: "control.php"))")!, completion: {
            (data, response, error) in
            if(!(error != nil)) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    
                    self.serverVersion = (json["baseversion"]! as! Int);
                    if let latestNewsStr = json["latestNewsDate"] as? String {
                        let userDefault = UserDefaults.standard
                        let lastCheckedDateKey = "ULTodayLastNewsDate"
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
                    
                        if let lastCheckedDateStr = userDefault.string(forKey: lastCheckedDateKey),
                            let serverNewsDate = dateFormatter.date(from: latestNewsStr), let lastCheckedDate = dateFormatter.date(from: lastCheckedDateStr) {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                                if lastCheckedDate < serverNewsDate, let mainVc = self.window?.rootViewController as? MainViewController {
                                    mainVc.updateBadge(tabIndex: .news, badgeValue: "new")
                                }
                                userDefault.set(latestNewsStr, forKey: lastCheckedDateKey)
                                userDefault.synchronize()
                            })
                        }
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: nil, message: "Error happened, sorry!\nPlease mail to ulapp@ul.ie to report the incident!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)                }
                }
            } else {
                if((error! as NSError).code == -1009) {
                    // NSURLErrorNotConnectedToInternet = -1009
                    DispatchQueue.main.async{
                        let alert = UIAlertController(title: nil, message: "Please make sure there is internet connection and try again!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        
                    }
                } else if ([-1001, -1003, -1004].contains((error! as NSError).code)) {
                    // NSURLErrorTimedOut = -1001
                    // NSURLErrorCannotFindHost = -1003
                    // NSURLErrorCannotConnectToHost = -1004

                    DispatchQueue.main.async{
                        let alert = UIAlertController(title: nil, message: "Please make sure there is internet connection and try again!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in self.requestControl()}))
                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        
                    }
                    
                }
            }
        })

    }
    
    @objc func swipwView(_ sender : UISwipeGestureRecognizer){
        let tabBarController = self.window?.rootViewController as? UITabBarController
        if((tabBarController?.selectedIndex)! == 1 || (tabBarController?.selectedIndex)! == 3) {
            tabBarController?.dismiss(animated: true, completion: nil)
        }
        if(sender.direction == .left) {
            if((tabBarController?.selectedIndex)! < 4) {
                tabBarController?.selectedIndex += 1;
            }
        } else if (sender.direction == .right) {
            if((tabBarController?.selectedIndex)! > 0) {
                tabBarController?.selectedIndex -= 1;
            }
        }
    }
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        systemVersion = 5
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(AppDelegate.swipwView(_:)))
        swipeGestureLeft.direction = .left
        self.window?.addGestureRecognizer(swipeGestureLeft)
        
        swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(AppDelegate.swipwView(_:)))
        swipeGestureRight.direction = .right
        self.window?.addGestureRecognizer(swipeGestureRight)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainVc = storyboard.instantiateInitialViewController() as?
            MainViewController {
            self.mainVc = mainVc
            let homeVc = storyboard.instantiateViewController(withIdentifier: "TabHome")
            let newsVc = storyboard.instantiateViewController(withIdentifier: "TabNews")
            let classesVc = storyboard.instantiateViewController(withIdentifier: "TabClasses")
            let mapVc = storyboard.instantiateViewController(withIdentifier: "TabMap")
            let moreVc = storyboard.instantiateViewController(withIdentifier: "TabMore")
            
            if (NSKeyedUnarchiver.unarchiveObject(withFile: UserInfo.ArchiveURL.path) as? UserInfo) != nil {
                mainVc.setViewControllers([homeVc, newsVc, classesVc, mapVc, moreVc], animated: false)
            } else {
                mainVc.setViewControllers([homeVc, newsVc, mapVc, moreVc], animated: false)
            }
            
            window?.rootViewController = mainVc
            window?.makeKeyAndVisible()
        }
        
        let config = ULConfiguration()
        if config.loadDefaultConfigs() {
            config.fetchRemoteConfigs(TimeInterval(5)) { (status, error) in
                if status == .success {
                    // more operations
                    if let miniVersion = config.getNumber(ULRemoteConfigurationKey.miniAppVersion.rawValue) {
                        if miniVersion.intValue > self.systemVersion {
                            DispatchQueue.main.async{
                                let alert = UIAlertController(title: nil, message: "Your app version is out-of-date!\nPlease update to the latest version from App Store.!", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    if (NSKeyedUnarchiver.unarchiveObject(withFile: UserInfo.ArchiveURL.path) as? UserInfo) != nil {
                        if config.getBool(ULRemoteConfigurationKey.exameFeature.rawValue) {
                            self.mainVc?.showClassTab(true, animated: false)
                        } else {
                            self.mainVc?.showClassTab(false, animated: false)
                        }
                    }
                    if let blockMessage = config.getString(ULRemoteConfigurationKey.serviceBlockMessage.rawValue), blockMessage.lengthOfBytes(using: .utf8) > 0 {
                        let serviceUnavailableVc = ServiceUnavailableVC(nibName: "ServiceUnavailableVC", bundle: nil)
                        serviceUnavailableVc.strMessage = blockMessage
                        self.window?.rootViewController?.present(serviceUnavailableVc, animated: true, completion: nil)
                    }
                } else {
                    // more error handling
                }
            }
            self.remoteConfig = config
        }
 
        
//        FirebaseApp.configure()
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        
        requestControl()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("did register remote notification: \(deviceToken)")
        //Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register remote notification: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("did receive remote message: \(userInfo)")
        completionHandler(UIBackgroundFetchResult.newData)
        
        if let userInfo = userInfo as? [String: Any] {
            self.handlePush(userInfo: userInfo, postExcute: true)
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
}

// ios 10 message handling
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("did receive remote notification: \(userInfo)")
        
        if let userInfo = userInfo as? [String: Any] {
            self.handlePush(userInfo: userInfo, postExcute: false)
        }
        
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("did receive remote notification 2: \(userInfo)")
        
        if let userInfo = userInfo as? [String: Any] {
            self.handlePush(userInfo: userInfo, postExcute: false)
        }
        completionHandler()
    }
    
    func handlePush(userInfo: [String: Any], postExcute: Bool) {
        if let messageTypeStr =  userInfo[PushCommandKey.messageType.rawValue] as? String {
            if let messageType = PushMessageType(rawValue: messageTypeStr) {
                switch messageType {
                case .news:
                    if let tabIndexStr = userInfo[PushConfigurationKey.tabIndex.rawValue] as? String,
                        let badgeStr = userInfo[PushConfigurationKey.badge.rawValue] as? String,
                        let tabIndex = TabIndex(rawValue: tabIndexStr) {
                        if let badge = Int(badgeStr) {
                            if let mainVc = self.window?.rootViewController as? MainViewController {
                                mainVc.updateBadge(tabIndex: tabIndex, number: badge)
                            }
                        }
                    }
                    if let link = userInfo[PushConfigurationKey.link.rawValue] as? String, let rootVc = self.window?.rootViewController {
                        if !postExcute {
                            WebBrowserVC.openBroswer(rootVc, url: URL(string: link), title: nil, showCloseButton: false)
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                WebBrowserVC.openBroswer(rootVc, url: URL(string: link), title: nil, showCloseButton: false)
                            }
                        }
                    }
                case .emergency:
                    print("-- todo -- emergency")
                    break
                }
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Firebase did receive remote push: \(remoteMessage.appData)")
    }
}
