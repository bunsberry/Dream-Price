//
//  CategoryIC.swift
//  Dream Price Companion Extension
//
//  Created by Kostya Bunsberry on 21.07.2020.
//

import WatchKit

struct Category {
    var id: String?
    var type: String?
    var title: String?
}

struct Transaction {
    var id: String?
    var date: NSDate?
    var details: String?
    var budgetID: String?
    var categoryID: String?
}

protocol SecondDelegate {
    func dismissSecond()
}

class CategoryIC: WKInterfaceController, ThirdDelegate {
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    // TODO Getting from DB
    
    let categories: [Category] = [
        Category(id: "0", type: "spending", title: "🥑 Продукты"),
        Category(id: "1", type: "earning", title: "💼 Работа"),
        Category(id: "2", type: "budget", title: "📱 Приложение")
    ]
    
    var shownCategories: [Category] = []
    
    static public var transactionValue: Int!
    static public var budgetID: String!
    
    static public var delegate: SecondDelegate?

    override func awake(withContext context: Any?) {
        
        if CategoryIC.transactionValue < 0 {
            for category in categories {
                if category.type != "earning" {
                    shownCategories.append(category)
                }
            }
        } else {
            for category in categories {
                if category.type != "spending" {
                    shownCategories.append(category)
                }
            }
        }
        
        tableView.setNumberOfRows(shownCategories.count, withRowType: "categoryCell")
        
        for (index, category) in shownCategories.enumerated() {
            let row = tableView.rowController(at: index) as! CategoryRow
            
            row.category = category
            row.nameLabel.setText(category.title ?? "No title")
        }
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        presentController(withName: "transactionConstructor", context: nil)
        
        let selectedRow = table.rowController(at: rowIndex) as! CategoryRow
        
        TransactionIC.details = "\(CategoryIC.transactionValue ?? 0)"
        TransactionIC.budgetID = CategoryIC.budgetID
        TransactionIC.categoryID = selectedRow.category.id
        TransactionIC.delegate = self
    }
    
    func dismissThird() {
        CategoryIC.delegate?.dismissSecond()
    }
}
