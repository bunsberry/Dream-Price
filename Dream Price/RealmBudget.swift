//
//  RealmBudget.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import Foundation
import RealmSwift

@objc class RealmBudget: Object {
    
    dynamic var id: String?
    dynamic var name: String?
    dynamic var balance: Float?
    dynamic var type: String?
    
    convenience init(id: String, name: String, balance: Float, type: String) {
        self.init()
        self.id = id
        self.name = name
        self.balance = balance
        self.type = type
    }
}
