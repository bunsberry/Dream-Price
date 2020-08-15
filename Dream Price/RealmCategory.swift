//
//  RealmCategory.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import Foundation
import RealmSwift

class RealmCategory: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var sortInt: Int = 0
    
    convenience init(id: String, type: String, title: String, sortInt: Int) {
        self.init()
        self.id = id
        self.type = type
        self.title = title
        self.sortInt = sortInt
    }
}
