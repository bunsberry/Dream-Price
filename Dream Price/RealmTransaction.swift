//
//  RealmTransaction.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import Foundation
import RealmSwift

@objcMembers class RealmTransaction: Object {
    dynamic var id: String?
    dynamic var details: String?
    dynamic var date: NSDate?
    dynamic var categories = List<RealmCategory>()
    
    convenience init(id: String, details: String, date: NSDate) {
        self.init()
        self.id = id
        self.details = details
        self.date = date
    }
}
