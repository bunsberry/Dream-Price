//
//  EditTransactionVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

protocol TransactionDelegate {
    func deleteTransaction()
    func rewriteCategory(string: String)
    func rewriteDesctiption(string: String)
    func rewriteNumber(float: Float)
    func rewriteDate(date: Date)
}

class EditTransactionVC: UIViewController, TransactionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: Transaction!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if data.number > 0 {
            navigationTitle.title = "Доход"
        } else {
            navigationTitle.title = "Расход"
        }
        
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if data.number == 0 {
            deleteTransaction()
        } else {
            // TODO: Saving changes to database
            dismiss(animated: true, completion: nil)
        }
    }
    
    func deleteTransaction() {
        let deleteMenu = UIAlertController(title: "Вы уверены?", message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            // TODO: Deleting from database
            print("Transaction deleted")
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        
        deleteMenu.addAction(deleteAction)
        deleteMenu.addAction(cancelAction)
        
        self.present(deleteMenu, animated: true, completion: nil)
        
    }
    
    func rewriteCategory(string: String) {
        
    }
    
    func rewriteDesctiption(string: String) {
        print("Description changed to \(string)")
        data.description = string
        self.view.endEditing(true)
    }
    
    func rewriteNumber(float: Float) {
        print("Number changed to \(float)")
        data.number = float
    }
    
    func rewriteDate(date: Date) {
        
    }
    
}

extension EditTransactionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Категория"
        case 1:
            return "Описание"
        case 2:
            return "Сумма"
        case 3:
            return "Дата"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 { return 2 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCategoryCell") as! ETCategoryCell
            
            cell.textField.text = data.category
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionDescriptionCell") as! ETDescriptionCell
            
            cell.textField.text = data.description
            cell.delegate = self
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCostCell") as! ETNumberCell
            
//            if var localeCurrency = Locale.current.currencySymbol {
//                if localeCurrency == "RUB" { localeCurrency = "₽" }
//            }
            
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 0
            numberFormatter.minimumFractionDigits = 0
            let cost = numberFormatter.string(from: NSNumber(value: data.number))
            
            if data.number < 0 {
                cell.textField.text = "\(cost!)"
            } else {
                cell.textField.text = "+\(cost!)"
            }
            cell.delegate = self
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionDateCell") as! ETDateCell
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionDeleteCell") as! ETDeleteCell
            
            cell.delegate = self
            
            return cell
        default:
            print("Section was never found")
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCategoryCell") as! ETCategoryCell
            
            return cell
        }
    }
    
}
