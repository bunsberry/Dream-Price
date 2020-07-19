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
    
    convenience init(id: String, title: String) {
        self.init()
        self.id = id
        self.title = title
    }
}
