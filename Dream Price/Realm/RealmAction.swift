//
//  RealmAction.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import Foundation
import RealmSwift

class RealmAction: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var isCompleted: Bool = false
    @objc dynamic var dateCompleted: NSDate?
    
    convenience init(id: String, name: String, isCompleted: Bool, dateCompleted: Date?) {
        self.init()
        self.id = id
        self.name = name
        self.isCompleted = isCompleted
        self.dateCompleted = dateCompleted as NSDate?
    }
}
