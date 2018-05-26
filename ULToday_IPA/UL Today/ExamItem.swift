//
//  ExamItem.swift
//  UL Today
//
//  Created by Andrew on 10/11/2017.
//  Copyright © 2017 Andrew Design. All rights reserved.
//

import UIKit

class ExamItem: NSObject {
    // MARK: Properties
    
    var module: String
    var title: String
    var timelabel: String
    var datelabel: String
    var utimestamp: Int
    var datetime: String
    var day: String
    var building: String
    var location: String
    var otherinformation: String
    
    // MARK: Initialization
    
    init?(module: String, title: String, timelabel: String, datelabel: String, utimestamp: Int, datetime: String, day: String, building: String, location: String, otherinformation: String) {
        // Initialize stored properties.
        self.module = module
        self.title = title
        self.timelabel = timelabel
        self.datelabel = datelabel
        self.utimestamp = utimestamp
        self.datetime = datetime
        self.day = day
        self.building = building
        self.location = location
        self.otherinformation = otherinformation
        
        super.init()
        
        if module.isEmpty || title.isEmpty {
            return nil
        }
    }
}


