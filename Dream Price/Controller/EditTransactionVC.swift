//
//  EditTransactionVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit
import RealmSwift

protocol TransactionDelegate {
    func deleteTransaction()
    func rewriteCategory(id: String?)
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
    var startData: Transaction!
    var historyDelegate: HistoryDelegate?
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var categoriesPickerOpened: Bool = false
    var budgetsPickerOpened: Bool = false
    
    var datePickerIndexPath: IndexPath?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        
        startData = data
        
        if data.transactionAmount > 0 {
            navigationTitle.title = NSLocalizedString("Earning", comment: "")
        } else {
            navigationTitle.title = NSLocalizedString("Spending", comment: "")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupTextFields()
    }
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero,
                                              size: .init(width: view.frame.size.width, height: 30)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self,
                                         action: #selector(doneButtonAction))
        doneButton.tintColor = #colorLiteral(red: 0.3075794578, green: 0.8026421666, blue: 0.3980509043, alpha: 1)
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ETNumberCell
        cell.textField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if data.transactionAmount == 0 {
            deleteTransaction()
            historyDelegate?.reloadTransactions()
        } else {
            let transactionsRealm = realm.objects(RealmTransaction.self)
            let budgetsRealm = realm.objects(RealmBudget.self)
            
            for object in transactionsRealm {
                if object.id == data.transactionID {
                    try! realm.write {
                        object.categoryID = data.categoryID
                        object.toBudget = data.toBudget
                        object.fromBudget = data.fromBudget
                        object.date = data.date as NSDate
                        object.transactionAmount = data.transactionAmount
                    }
                }
            }
            
            if data.fromBudget != startData.fromBudget {
                for object in budgetsRealm {
                    if object.id == startData.fromBudget {
                        try! realm.write {
                            object.balance -= data.transactionAmount
                        }
                    }
                    if object.id == data.fromBudget {
                        try! realm.write {
                            object.balance += data.transactionAmount
                        }
                    }
                }
            }
            
            if data.toBudget != startData.toBudget {
                if startData.toBudget == nil {
                    for object in budgetsRealm {
                        if object.id == data.toBudget {
                            try! realm.write {
                                object.balance -= data.transactionAmount
                            }
                        }
                    }
                } else if startData.toBudget != nil && data.toBudget != nil {
                    for object in budgetsRealm {
                        if object.id == startData.toBudget {
                            try! realm.write {
                                object.balance += data.transactionAmount
                            }
                        }
                        if object.id == data.toBudget {
                            try! realm.write {
                                object.balance -= data.transactionAmount
                            }
                        }
                    }
                } else if startData.toBudget != nil && data.toBudget == nil {
                    for object in budgetsRealm {
                        if object.id == startData.toBudget {
                            try! realm.write {
                                object.balance += data.transactionAmount
                            }
                        }
                    }
                }
            }
            
            if startData.transactionAmount != data.transactionAmount {
                for object in budgetsRealm {
                    if object.id == data.fromBudget {
                        try! realm.write {
                            if data.transactionAmount < 0 {
                                if data.transactionAmount > startData.transactionAmount {
                                    // -20 -> -5 | +15 (--15)
                                    object.balance -= (startData.transactionAmount - data.transactionAmount)
                                } else {
                                    // -5 -> -20 | -15 (+-15)
                                    object.balance += (data.transactionAmount - startData.transactionAmount)
                                }
                            } else {
                                if data.transactionAmount > startData.transactionAmount {
                                    object.balance += (data.transactionAmount - startData.transactionAmount)
                                } else {
                                    object.balance -= (startData.transactionAmount - data.transactionAmount)
                                }
                            }
                        }
                    }
                }
            }
            
            historyDelegate?.reloadTransactions()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func deleteTransaction() {
        let deleteMenu = UIAlertController(title: NSLocalizedString("Are you sure?", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let transactionsRealm = self.realm.objects(RealmTransaction.self)
            let budgetsRealm = self.realm.objects(RealmBudget.self)
            let projectsRealm = self.realm.objects(RealmProject.self)
            
            for object in transactionsRealm {
                if object.id == self.data.transactionID {
                    if self.startData.transactionAmount > 0 {
                        
                        for budget in budgetsRealm {
                            if self.startData.fromBudget == budget.id {
                                try! self.realm.write {
                                    budget.balance -= self.startData.transactionAmount
                                }
                            }
                            
                            if let toBudget = self.startData.toBudget {
                                if budget.id == toBudget {
                                    try! self.realm.write {
                                        budget.balance += self.startData.transactionAmount
                                    }
                                }
                            }
                        }
                        
                        for project in projectsRealm {
                            if self.startData.fromBudget == project.id {
                                try! self.realm.write {
                                    project.balance -= self.startData.transactionAmount
                                }
                            }
                            
                            if let toBudget = self.startData.toBudget {
                                if project.id == toBudget {
                                    try! self.realm.write {
                                        project.balance += self.startData.transactionAmount
                                    }
                                }
                            }
                        }
                        
                    } else {
                        
                        for budget in budgetsRealm {
                            if self.startData.fromBudget == budget.id {
                                try! self.realm.write {
                                    budget.balance -= self.startData.transactionAmount
                                }
                            }
                            
                            if let toBudget = self.startData.toBudget {
                                if budget.id == toBudget {
                                    try! self.realm.write {
                                        budget.balance += self.startData.transactionAmount
                                    }
                                }
                            }
                        }
                        
                        for project in projectsRealm {
                            if self.startData.fromBudget == project.id {
                                try! self.realm.write {
                                    project.balance -= self.startData.transactionAmount
                                }
                            }
                            
                            if let toBudget = self.startData.toBudget {
                                if project.id == toBudget {
                                    try! self.realm.write {
                                        project.balance += self.startData.transactionAmount
                                    }
                                }
                            }
                        }
                    }
                    
                    try! self.realm.write {
                        self.realm.delete(object)
                    }
                }
            }
            
            self.historyDelegate?.reloadTransactions()
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        deleteMenu.addAction(deleteAction)
        deleteMenu.addAction(cancelAction)
        
        self.present(deleteMenu, animated: true, completion: nil)
        
    }
    
    func rewriteCategory(id: String?) {
        data.categoryID = id
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! ETCategoryCell
        
        if let categoryID = data.categoryID {
            let categoriesRealm = realm.objects(RealmCategory.self)
            for object in categoriesRealm {
                if object.id == categoryID {
                    cell.titleLabel.text = object.title
                }
            }
        } else {
            cell.titleLabel.text = "None"
        }
    }
    
    func rewriteBudget(id: String) {
        data.fromBudget = id
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! ETBudgetCell
        
        let budgetsRealm = realm.objects(RealmBudget.self)
        for object in budgetsRealm {
            if object.id == data.fromBudget {
                cell.titleLabel.text = object.name
            }
        }
    }
    
    func rewriteNumber(float: Float) {
        data.transactionAmount = float
    }
    
    func rewriteDate(date: Date) {
        data.date = date
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! ETDateCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        cell.dateLabel.text = dateFormatter.string(from: date)
    }
    
}

extension EditTransactionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("Amount", comment: "")
        case 1:
            return NSLocalizedString("Budget", comment: "")
        case 2:
            return NSLocalizedString("Category", comment: "")
        case 3:
            return NSLocalizedString("Date", comment: "")
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 1
        
        if datePickerIndexPath != nil && datePickerIndexPath?.section == section { rows += 1 }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCostCell") as! ETNumberCell
            
            let numberFormatter = NumberFormatter()
            
            if Settings.shared.recordCentsOn! {
                numberFormatter.maximumFractionDigits = 2
                numberFormatter.minimumFractionDigits = 2
            } else {
                numberFormatter.maximumFractionDigits = 0
                numberFormatter.minimumFractionDigits = 0
            }
            
            let amount = numberFormatter.string(from: NSNumber(value: data.transactionAmount))
            
            if data.transactionAmount > 0 {
                cell.textField.text = "+\(amount!)"
                cell.textField.textColor = UIColor(red: 0.451, green: 0.792, blue: 0.443, alpha: 1)
            } else {
                cell.textField.text = "\(amount!)"
                cell.textField.textColor = UIColor(red: 0.792, green: 0.443, blue: 0.443, alpha: 1)
            }
            cell.delegate = self
            
            return cell
        case IndexPath(row: 0, section: 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionBudgetCell") as! ETBudgetCell
            
            let budgetsRealm = realm.objects(RealmBudget.self)
            for object in budgetsRealm {
                if object.id == data.fromBudget {
                    cell.titleLabel.text = object.name
                }
            }
            let projectsRealm = realm.objects(RealmProject.self)
            for object in projectsRealm {
                if object.id == data.fromBudget {
                    cell.titleLabel.text = object.name
                }
            }
            
            return cell
        case IndexPath(row: 1, section: 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionBudgetPickerCell") as! ETBudgetPickerCell
            
            cell.delegate = self
            
            return cell
        case IndexPath(row: 0, section: 2):
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCategoryCell") as! ETCategoryCell
            
            
            if let categoryID = data.categoryID {
                let categoriesRealm = realm.objects(RealmCategory.self)
                for object in categoriesRealm {
                    if object.id == categoryID {
                        cell.titleLabel.text = object.title
                    }
                }
            } else {
                cell.titleLabel.text = "None"
            }
            
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionDateCell") as! ETDateCell
            
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar.current
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            cell.dateLabel.text = dateFormatter.string(from: data.date)
            
            return cell
        case IndexPath(row: 1, section: 3):
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionDatePickerCell") as! ETDatePickerCell
            
            cell.datePicker.date = data.date
            cell.datePicker.maximumDate = Date()
            cell.delegate = self
            
            return cell
        case IndexPath(row: 0, section: 4):
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionDeleteCell") as! ETDeleteCell
            
            cell.delegate = self
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCategoryCell") as! ETCategoryCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        if datePickerIndexPath != nil && datePickerIndexPath?.section == indexPath.section && datePickerIndexPath!.row - 1 == indexPath.row {
            tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
            datePickerIndexPath = nil
        } else {
            if datePickerIndexPath != nil {
                tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
            }
            datePickerIndexPath = calculatePickerIndexPath(indexPathSelected: indexPath)
            tableView.insertRows(at: [datePickerIndexPath!], with: .fade)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.endUpdates()
    }

    func calculatePickerIndexPath(indexPathSelected: IndexPath) -> IndexPath {
        if datePickerIndexPath != nil && datePickerIndexPath!.row  < indexPathSelected.row {
            return IndexPath(row: indexPathSelected.row, section: indexPathSelected.section)
        } else {
            return IndexPath(row: indexPathSelected.row + 1, section: indexPathSelected.section)
        }
    }
    
}
