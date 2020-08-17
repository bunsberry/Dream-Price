//
//  Dream.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 17.08.2020.
//

import Foundation

enum DreamType: String {
    case focusedDream
    case dream
}

struct Dream {
    var dreamID: String
    var type: DreamType
    var title: String
    var description: String
    var balance: Float
    var goal: Float
    var dateAdded: Date
}
