//
//  UserInfo.swift
//  UL Timetable
//
//  Created by Andrew on 8/9/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit

import UIKit

class UserInfo: NSObject, NSCoding {
    // MARK: Type
    struct  PropertyKey {
        static let roleKey = "role"
        static let idKey = "id"
    }
    
    // MARK: Properties
    var role: String
    var id: String
    
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ul-timetable")
    
    // MARK: Initialization
    init?(role: String, id: String){
        self.role = role
        self.id = id
        
        super.init()
        
        if role.isEmpty || id.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(role, forKey: PropertyKey.roleKey)
        aCoder.encode(id, forKey: PropertyKey.idKey)

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: PropertyKey.idKey) as! String
        let role = aDecoder.decodeObject(forKey: PropertyKey.roleKey) as! String
        
        self.init(role: role, id: id)
        
        
    }
    
}
