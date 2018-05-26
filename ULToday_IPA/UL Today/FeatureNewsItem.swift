//
//  FeatureNewsItem.swift
//  UL Today
//
//  Created by Andrew on 07/11/2017.
//  Copyright © 2017 Andrew Design. All rights reserved.
//

import UIKit

class FeatureNewsItem: NSObject {
    // MARK: Properties
    
    var title: String
    var text: String
    var link: String
    var img: String
    
    // MARK: Initialization
    
    init?(title: String, text: String, link: String, img: String) {
        // Initialize stored properties.
        
        self.title = title
        self.text = text
        self.link = link
        self.img = img
        
        super.init()
        
        if text.isEmpty || link.isEmpty || img.isEmpty || title.isEmpty {
            return nil
        }
    }
}
