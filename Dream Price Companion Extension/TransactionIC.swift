//
//  TransactionIC.swift
//  Dream Price Companion Extension
//
//  Created by Kostya Bunsberry on 21.07.2020.
//

import WatchKit
import Foundation

protocol ThirdDelegate {
    func dismissThird()
}

class TransactionIC: WKInterfaceController {
    
    var id: String?
    var date: NSDate?
    public static var details: String!
    public static var budgetID: String!
    public static var categoryID: String!
    
    public static var delegate: ThirdDelegate?
    
    var newTransaction: Transaction?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // TODO Generate id
        id = "1"
        
        newTransaction = Transaction(id: id, date: NSDate(), details: TransactionIC.details, budgetID: TransactionIC.budgetID, categoryID: TransactionIC.categoryID)
    }
    
    @IBAction func done() {
        TransactionIC.delegate?.dismissThird()
    }
}
