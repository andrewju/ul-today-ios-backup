//
//  AppDelegate.swift
//  UL Timetable
//
//  Created by Andrew on 16/8/8.
//  Copyright © 2016年 Andrew Design. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var systemVersion: Int?
    var serverResponse: Int?
    var serverVersion: Int?
    
    var swipeGestureLeft  = UISwipeGestureRecognizer()
    var swipeGestureRight  = UISwipeGestureRecognizer()
    
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
        self.request(requestURL: URL.init(string: "https://ul-today-app.appspot.com/control")!, completion: {
            (data, response, error) in
            if(!(error != nil)) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    
                    self.serverVersion = (json["baseversion"]! as! Int);
                    
                    if(self.serverVersion! > self.systemVersion!) { // force upgrade
                        DispatchQueue.main.async{
                            let alert = UIAlertController(title: nil, message: "Your app version is out-of-date!\nPlease update to the latest version from App Store.!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                            self.window?.rootViewController?.present(alert, animated: true, completion: nil)                }
                    } else { // perfect
                        //let tabBarController = self.window?.rootViewController as? UITabBarController



                    }
                    
                    
                } catch {
                    print("error serializing JSON: \(error)")
                    
                    DispatchQueue.main.async{
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
        systemVersion = 2
        requestControl()
        
        swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(AppDelegate.swipwView(_:)))
        swipeGestureLeft.direction = .left
        self.window?.addGestureRecognizer(swipeGestureLeft)
        
        swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(AppDelegate.swipwView(_:)))
        swipeGestureRight.direction = .right
        self.window?.addGestureRecognizer(swipeGestureRight)
        return true
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

