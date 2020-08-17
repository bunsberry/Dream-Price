//
//  ETBudgetPickerCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 27.07.2020.
//

import UIKit
import RealmSwift

class ETBudgetPickerCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate: TransactionDelegate?
    let realm = try! Realm()
    
    var budgets = [BudgetItem]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        budgets.removeAll()
        let budgetsRealm = realm.objects(RealmBudget.self)
        for object in budgetsRealm {
            budgets.append(BudgetItem(budgetID: object.id, type: BudgetItemType(rawValue: object.type)!, balance: object.balance, name: object.name))
        }
        
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
