//
//  Project.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 25.08.2020.
//

import Foundation

struct Project {
    var id: String = UUID().uuidString
    var name: String = ""
    var details: String = ""
    var isFinished: Bool = false
    var isBudget: Bool = false
    var budget: Float = 0
    var balance: Float = 0
    var dateFinished: Date? = nil
}

struct Action {
    var id: String = UUID().uuidString
    var projectID: String!
    var text: String!
    var isCompleted: Bool = false
    var dateCompleted: Date?
}
