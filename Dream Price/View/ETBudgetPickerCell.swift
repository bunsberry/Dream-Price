//
//  ETBudgetPickerCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 27.07.2020.
//

import UIKit

class ETBudgetPickerCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate: TransactionDelegate?
    
    var budgets = [
        BudgetItem(budgetID: UUID().uuidString, type: .personal, balance: 222, name: "Personal Account"),
        BudgetItem(budgetID: UUID().uuidString, type: .dream, balance: 222, name: "Dream"),
        BudgetItem(budgetID: UUID().uuidString, type: .project, balance: 222, name: "Project"),
    ]

    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return budgets.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return budgets[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.rewriteBudget(id: budgets[row].budgetID)
    }

}
