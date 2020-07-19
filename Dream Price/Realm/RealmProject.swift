//
//  RealmProject.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import Foundation
import RealmSwift

@objc class RealmProject: Object {
    dynamic var id: String?
    dynamic var name: String?
    dynamic var budget: Float?
    dynamic var actions = List<RealmAction>()
    
    convenience init(id: String, name: String, budget: Float) {
        self.init()
        self.id = id
        self.name = name
        self.budget = budget
    }
}
