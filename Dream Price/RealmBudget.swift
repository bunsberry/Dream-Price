//
//  RealmBudget.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import Foundation
import RealmSwift

class RealmBudget: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var balance: Float = 0
    @objc dynamic var type: String = ""
    
    convenience init(id: String, name: String, balance: Float, type: String) {
        self.init()
        self.id = id
        self.name = name
        self.balance = balance
        self.type = type
    }
}
