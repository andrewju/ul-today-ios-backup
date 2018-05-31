//
//  ULConfiguration.swift
//  UL Today
//
//  Created by Shilei Mao on 26/05/2018.
//  Copyright © 2018 Andrew Design. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseRemoteConfig

enum ULRemoteConfigurationKey: String {
    case serverHost = "server_prefix"
    case miniAppVersion = "minimal_version_ipa"
    case exameFeature = "show_class_tab"
    case serviceControl = "service_name_control"
    case serviceLibrary = "service_name_library"
    case serviceBookshop = "service_name_bookshop"
    case serviceArena = "service_name_arena"
    case serviceHomeFeature = "service_name_home_feature"
    case serviceAlerts = "service_name_alerts"
    case serviceTwitter = "service_name_twitter"
    case serviceEvents = "service_name_events"
    case serviceTimeTable = "service_name_time_table"
    case serviceInstagram = "service_name_instagram"
}

enum PushCommandKey: String {
    case messageType
}

enum PushMessageType: String {
    case news
    case emergency
}
enum PushConfigurationKey: String {
    case link
    case badge
    case title
    case message
    case tabIndex
}

class ULConfiguration: NSObject {
    var remoteCofig: RemoteConfig?
    func loadDefaultConfigs() -> Bool {
        FirebaseApp.configure()
        let remoteConfi = RemoteConfig.remoteConfig()
        
        if let path = Bundle.main.path(forResource: "ULRemoteConfDefaults", ofType: "plist"), let defaultConfigs = NSDictionary(contentsOfFile: path) as? [String: NSObject] {
            let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
            remoteConfi.configSettings = remoteConfigSettings
            remoteConfi.setDefaults(defaultConfigs)
            self.remoteCofig = remoteConfi
            
            return true
        } else {
            print("Waring!!! failed to load the default configurations")
            return false
        }
    }
    
    func fetchRemoteConfigs(_ timeoutDuration: TimeInterval, callback: @escaping (_ status: RemoteConfigFetchStatus, _ error: Error?) -> Void) {
        
        self.remoteCofig?.fetch(withExpirationDuration: TimeInterval(5)) { (status, error) in
            if status == .success {
                self.remoteCofig?.activateFetched()
                callback(status, error)
            } else {
                print("Waring!!! failed to fetch remote configurations")
                callback(status, error)
            }
        }
    }
    
    func getString(_ forKey: String) -> String? {
        return remoteCofig?[forKey].stringValue
    }
    
    func getBool(_ forKey: String) -> Bool {
        return remoteCofig?[forKey].boolValue ?? false
    }
    
    func getNumber(_ forKey: String) -> NSNumber? {
        return remoteCofig?[forKey].numberValue
    }
    
    var serverHost: String {
        return getString(ULRemoteConfigurationKey.serverHost.rawValue) ?? "35.197.202.71"
    }
    
    func getServiceName(_ key: String, defaultValue: String) -> String {
        return getString(key) ?? defaultValue
    }
}
