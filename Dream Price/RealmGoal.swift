//
//  RealmGoal.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import Foundation
import RealmSwift

@objc class RealmGoal: Object {
    dynamic var id: String?
    dynamic var name: String?
    dynamic var expectedValue: Float?
    dynamic var currentValue: Float?
    
    convenience init(id: String, name: String, expectedValue: Float, currentValue: Float) {
        self.init()
        self.id = id
        self.name = name
        self.expectedValue = expectedValue
        self.currentValue = currentValue
    }
}
