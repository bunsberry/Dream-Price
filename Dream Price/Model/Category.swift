//
//  Category.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import Foundation

enum CategoryType {
    case new
    case manage
    case spending
    case earning
    case budget
}

struct Category {
    let id: Int
    let type: CategoryType
    let title: String
}
