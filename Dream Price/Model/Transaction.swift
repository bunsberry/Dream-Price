//
//  Transaction.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 17.08.2020.
//

import Foundation

struct Transaction {
    var transactionID: String
    var transactionAmount: Float
    var categoryID: String?
    var date: Date
    var fromBudget: String
    var toBudget: String?
}
