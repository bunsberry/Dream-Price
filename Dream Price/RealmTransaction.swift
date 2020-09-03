//
//  RealmTransaction.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import Foundation
import RealmSwift

class RealmTransaction: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var transactionAmount: Float = 0.0
    @objc dynamic var date: NSDate = NSDate()
    @objc dynamic var categoryID: String?
    @objc dynamic var fromBudget: String = ""
    @objc dynamic var toBudget: String?
    
    convenience init(id: String, transactionAmount: Float, categoryID: String?, date: NSDate, fromBudget: String, toBudget: String?) {
        self.init()
        self.id = id
        self.transactionAmount = transactionAmount
        self.categoryID = categoryID
        self.date = date
        self.fromBudget = fromBudget
        self.toBudget = toBudget
    }
}
