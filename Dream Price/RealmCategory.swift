//
//  RealmCategory.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import Foundation
import RealmSwift

@objc class RealmCategory: Object {
    dynamic var id: String?
    dynamic var title: String?
    dynamic var type: String?
    dynamic var sortInt: Int?
    convenience init(id: String, title: String, type: String, sortInt: Int) {
        self.init()
        self.id = id
        self.title = title
        self.type = type
        self.sortInt = sortInt
    }
}
