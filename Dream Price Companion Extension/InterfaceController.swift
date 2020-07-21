//
//  InterfaceController.swift
//  Dream Price Companion Extension
//
//  Created by Kostya Bunsberry on 21.07.2020.
//

import WatchKit

struct Budget {
    var id: String?
    var name: String?
    var balance: Float?
    var type: String?
}

class InterfaceController: WKInterfaceController, FirstDelegate {
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    // TODO Getting from DB
    
    let budgets: [Budget] = [
        Budget(id: "0", name: "Личный Счет", balance: 400, type: ".personal"),
        Budget(id: "1", name: "Мечта", balance: 200, type: ".dream"),
        Budget(id: "2", name: "Проект", balance: 300, type: ".project")
    ]

    override func awake(withContext context: Any?) {
        
        tableView.setNumberOfRows(budgets.count, withRowType: "budgetCell")
        
        for (index, account) in budgets.enumerated() {
            let row = tableView.rowController(at: index) as! BudgetCell
            
            row.budgetItem = account
            row.nameLabel.setText(account.name ?? "No title")
        }
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        presentController(withName: "transactionValue", context: nil)
        ValueChangeIC.delegate = self
        
        let selectedRow = table.rowController(at: rowIndex) as! BudgetCell
        ValueChangeIC.budget = selectedRow.budgetItem
    }
    
    func dismissFirst() {
        DispatchQueue.main.async {
            self.dismiss()
        }
    }
}
