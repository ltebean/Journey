//
//  Moment.swift
//  Journey
//
//  Created by ltebean on 16/2/18.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import RealmSwift

class Moment: Object {
    
    dynamic var uuid: String = NSUUID().UUIDString
    dynamic var date: NSDate = NSDate()
    dynamic var photoUuid: String = ""
    dynamic var title: String = ""
    dynamic var text: String = ""
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}

