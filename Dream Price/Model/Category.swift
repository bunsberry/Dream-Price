//
//  Category.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import Foundation

enum CategoryType {
    case manage
    case spendind
    case earning
    case budget
}

struct Category {
    let type: CategoryType
    let title: String
}
