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
    dynamic var dateCompleted: NSDate?
    dynamic var completed: Bool?
    
    convenience init(id: String, name: String, dateCompleted: NSDate?, completed: Bool) {
        self.init()
        self.id = id
        self.name = name
        self.dateCompleted = dateCompleted
        self.completed = completed
    }
}
