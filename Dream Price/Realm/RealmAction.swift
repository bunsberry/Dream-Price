//
//  RealmAction.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import Foundation
import RealmSwift

@objc class RealmAction: Object {
    dynamic var id: String?
    dynamic var name: String?
    dynamic var details: String?
    dynamic var date: NSDate?
    dynamic var completed: Bool?
    
    convenience init(id: String, name: String, details: String, date: NSDate, completed: Bool) {
        self.init()
        self.id = id
        self.name = name
        self.details = details
        self.date = date
        self.completed = completed
    }
}
