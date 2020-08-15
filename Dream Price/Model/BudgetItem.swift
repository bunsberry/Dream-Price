//
//  BudgetItem.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import Foundation

enum BudgetItemType: String {
    case project
    case personal
    case dream
}

struct BudgetItem {
    
    let budgetID: String
    let type: BudgetItemType
    let balance: Float
    let name: String
    
}
