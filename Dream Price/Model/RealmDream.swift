//
//  RealmDream.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 17.08.2020.
//

import Foundation
import RealmSwift

class RealmDream: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var descript: String = ""
    @objc dynamic var goal: Float = 0.0
    @objc dynamic var type: String = "dream"
    @objc dynamic var dateAdded: NSDate = NSDate()
    
    convenience init(title: String, description: String, goal: Float, type: String, dateAdded: Date) {
        self.init()
        self.title = title
        self.descript = description
        self.goal = goal
        self.type = type
        self.dateAdded = dateAdded as NSDate
    }
}
