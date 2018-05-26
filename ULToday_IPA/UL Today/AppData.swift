//
//  AppData.swift
//  UL Today
//
//  Created by Andrew on 21/08/2017.
//  Copyright © 2017 Andrew Design. All rights reserved.
//

import UIKit

class AppData: NSObject {
    
    static let shared = AppData()
    
    var version = 0
    var rtpiLink: String?
    var defaultURL: String?
    var campusMap = [AnyObject]()
    var morePage = [String:AnyObject]()
    var first7Weeks = [String]()
    var glucksmanLibrary = [String:AnyObject]()
    var usefulNumbers = [String:AnyObject]()
    var usefulInformation = [String:AnyObject]()
    
    
    // MARK: Initialization
    override init(){
        
        do {
            if let file = Bundle.main.url(forResource: "AppData", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    version = object["version"]! as! Int
                    defaultURL = (object["default_url"] as! String)
                    rtpiLink = (object["rtpi_link"]! as! String)
                    campusMap = object["campus_map"]! as! [AnyObject]
                    morePage = object["more_page"]! as! [String:AnyObject]
                    first7Weeks = object["first_seven_weeks"]! as! [String]
                    glucksmanLibrary = object["glucksman_library"]! as! [String:AnyObject]
                    usefulNumbers = object["useful_numbers"]! as! [String:AnyObject]
                    usefulInformation = object["useful_information"]! as! [String:AnyObject]
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no AppData.json file exists")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
