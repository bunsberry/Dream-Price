//
//  Category.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import Foundation

enum CategoryType: String {
    case new = "new"
    case manage = "manage"
    case spending = "spending"
    case earning = "earning"
    case budget = "budget"
}

struct Category {
    var id: String
    var type: CategoryType
    var title: String
    var sortInt: Int
}
