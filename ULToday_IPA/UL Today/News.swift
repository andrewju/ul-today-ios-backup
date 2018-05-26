//
//  NewsItem.swift
//  UL Timetable
//
//  Created by Andrew on 16/8/8.
//  Copyright © 2016年 Andrew Design. All rights reserved.
//

import UIKit

class NewsItem: NSObject {
    
    // MARK: Properties
    var type: String
    var title: String
    var date: String
    var photo: String
    var text: String
    var link: String
    
    // MARK: Initialization
    init?(type: String, title: String, date: String, photo: String, text: String, link: String){
        self.type = type
        self.title = title
        self.date = date
        self.photo = photo
        self.text = text
        self.link = link
        
        super.init()
        
        if title.isEmpty || date.isEmpty || link.isEmpty {
            return nil
        }
    }

}
