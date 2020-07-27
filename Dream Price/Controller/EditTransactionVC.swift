//
//  EditTransactionVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

protocol TransactionDelegate {
    func deleteTransaction()
    func rewriteCategory(id: String)
    func rewriteBudget(id: String)
    func rewriteNumber(float: Float)
    func rewriteDate(date: Date)
}

protocol HistoryDelegate {
    func reloadTransactions()
}

class EditTransactionVC: UIViewController, TransactionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: Transaction!
    var historyDelegate: HistoryDelegate?
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var categoriesPickerOpened: Bool = false
    var budgetsPickerOpened: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if data.transactionAmount > 0 {
            navigationTitle.title = NSLocalizedString("Earning", comment: "")
        } else {
            navigationTitle.title = NSLocalizedString("Spending", comment: "")
        }
        
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if data.transactionAmount == 0 {
            deleteTransaction()
        } else {
            // TODO: Saving changes to database
            print("\(data.transactionID) changed to \(data)")
            historyDelegate?.reloadTransactions()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func deleteTransaction() {
        let deleteMenu = UIAlertController(title: NSLocalizedString("Are you sure?", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            print("should delete transaction with id = \(self.data.transactionID)")
            // TODO: Deleting from database
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        deleteMenu.addAction(deleteAction)
        deleteMenu.addAction(cancelAction)
        
        self.present(deleteMenu, animated: true, completion: nil)
        
    }
    
    func rewriteCategory(id: String) {
        data.categoryID = id
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! ETCategoryCell
        cell.titleLabel.text = id
    }
    
    func rewriteBudget(id: String) {
        data.budgetFromID = id
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! ETBudgetCell
        cell.titleLabel.text = id
    }
    
    func rewriteNumber(float: Float) {
        data.transactionAmount = float
    }
    
    func rewriteDate(date: Date) {
        // TODO: Date rewriting
    }
    
}

extension EditTransactionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 5
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("Amount", comment: "")
        case 1:
            return NSLocalizedString("Budget", comment: "")
        case 2:
            return NSLocalizedString("Category", comment: "")
//        case 3:
//            return NSLocalizedString("Date", comment: "")
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categoriesPickerOpened && budgetsPickerOpened{
            if section == 1 || section == 2 { return 2 }
            return 1
        } else if categoriesPickerOpened {
            if section == 2 { return 2 }
            return 1
        } else if budgetsPickerOpened {
            if section == 1 { return 2 }
            return 1
        } else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCostCell") as! ETNumberCell
            
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 0
            numberFormatter.minimumFractionDigits = 0
            let amount = numberFormatter.string(from: NSNumber(value: data.transactionAmount))
            
            if data.transactionAmount < 0 {
                cell.textField.text = "\(amount!)"
            } else {
                cell.textField.text = "+\(amount!)"
            }
            cell.delegate = self
            
            return cell
        case IndexPath(row: 0, section: 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionBudgetCell") as! ETBudgetCell
            
            cell.titleLabel.text = data.budgetFromID
            
            return cell
        case IndexPath(row: 1, section: 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionBudgetPickerCell") as! ETBudgetPickerCell
            
            cell.delegate = self
            
            return cell
        case IndexPath(row: 0, section: 2):
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCategoryCell") as! ETCategoryCell
            
            cell.titleLabel.text = data.categoryID
            
            return cell
        case IndexPath(row: 1, section: 2):
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionPickerCell") as! ETPickerCell
            
            if data.transactionAmount > 0 {
                cell.pickerMode = 1
            } else {
                cell.pickerMode = 0
            }
            
            cell.delegate = self
            
            return cell
        case IndexPath(row: 0, section: 3):
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionDeleteCell") as! ETDeleteCell
            
            cell.delegate = self
            
            return cell
        default:
            print("Section was never found")
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCategoryCell") as! ETCategoryCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 2) {
            categoriesPickerOpened = !categoriesPickerOpened
        }
        
        if indexPath == IndexPath(row: 0, section: 1) {
            budgetsPickerOpened = !budgetsPickerOpened
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
}
