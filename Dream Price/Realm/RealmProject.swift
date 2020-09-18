//
//  RealmProject.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import Foundation
import RealmSwift

class RealmProject: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var details: String = ""
    @objc dynamic var isFinished: Bool = false
    @objc dynamic var isBudget: Bool = false
    @objc dynamic var budget: Float = 0
    @objc dynamic var balance: Float = 0
    @objc dynamic var dateFinished: NSDate? = nil
    
    convenience init(name: String, details: String, isBudget: Bool, budget: Float) {
        self.init()
        self.name = name
        self.details = details
        self.isBudget = isBudget
        self.budget = budget
        self.balance = budget
    }
}
