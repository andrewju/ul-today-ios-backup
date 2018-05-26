//
//  TwitterData.swift
//  UL Timetable
//
//  Created by Andrew on 8/9/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit

class TwitterData: NSObject {
    // MARK: Properties
    
    var content: String
    var date: String
    var link: String
    
    // MARK: Initialization
    
    init?(content: String, date: String, link: String) {
        // Initialize stored properties.
        
        self.content = content
        self.date = date
        self.link = link
        
        super.init()
        
        if content.isEmpty || date.isEmpty {
            return nil
        }
    }
}
