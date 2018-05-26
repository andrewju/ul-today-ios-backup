//
//  ClassesItem.swift
//  UL Timetable
//
//  Created by Andrew on 8/9/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit

class ClassesItem: NSObject {
    // MARK: Properties
    
    var classTime: String
    var classType: String
    var classCode: String
    var classTitle: String
    var classSeq: String
    var classRoom: String
    var classDay: Int
    
    // MARK: Initialization
    
    init?(time: String, type: String, code: String, title: String, seq: String, room: String, day: Int) {
        // Initialize stored properties.
        self.classTime = time
        self.classType = type
        self.classCode = code
        self.classTitle = title
        self.classSeq = seq
        self.classRoom = room
        self.classDay = day
        
        super.init()
        
        if classCode.isEmpty || classTitle.isEmpty {
            return nil
        }
    }
}
