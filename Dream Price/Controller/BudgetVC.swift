//
//  BudgetVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit
import Foundation

protocol TransportUpDelegate {
    func transportUp(string: String)
}

class BudgetVC: UIViewController, BudgetDelegate, CategoriesBeenManaged {
    
    // TODO: Получение категорий из DB
    
    var categories: [Category] = [
        Category(categoryID: UUID().uuidString, type: .manage, title: "+", sortInt: 0),
        Category(categoryID: UUID().uuidString, type: .earning, title: NSLocalizedString("Work", comment: ""), sortInt: 0),
        Category(categoryID: UUID().uuidString, type: .spending, title: NSLocalizedString("Coffee", comment: ""), sortInt: 0),
        Category(categoryID: UUID().uuidString, type: .spending, title: NSLocalizedString("Groceries", comment: ""), sortInt: 1),
        Category(categoryID: UUID().uuidString, type: .budget, title: NSLocalizedString("Personal Account", comment: ""), sortInt: 0),
        Category(categoryID: UUID().uuidString, type: .budget, title: NSLocalizedString("App", comment: ""), sortInt: 1),
        Category(categoryID: UUID().uuidString, type: .budget, title: NSLocalizedString("Dream", comment: ""), sortInt: 2)
    ]
    
    var categoriesShown: [Category] = []

    public static var currentTransaction: String = "-"
    
    public static var delegateUp: TransportUpDelegate?
    
    @IBOutlet weak var budgetsViewContainer: UIView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonsSetup()
        updateCategories(transaction: "-", name: NSLocalizedString("Personal Account", comment: ""))
    }
    
    // MARK: Buttons setup
    
    func buttonsSetup() {
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)

        let largeBoldDelete = UIImage(systemName: "delete.left.fill", withConfiguration: largeConfig)
        let largeBoldDone = UIImage(systemName: "checkmark.circle.fill", withConfiguration: largeConfig)

//         button.setImage(largeBoldDoc, for: .normal)
        
        removeButton.setImage(largeBoldDelete?.withTintColor(.label, renderingMode:.alwaysOriginal), for: .normal)
        removeButton.setImage(largeBoldDelete?.withTintColor(.quaternaryLabel, renderingMode: .alwaysOriginal), for: .highlighted)
        removeButton.setImage(largeBoldDelete?.withTintColor(.secondaryLabel, renderingMode:.alwaysOriginal), for: .disabled)
        
        doneButton.setImage(largeBoldDone?.withTintColor(UIColor(red: 0.451, green: 0.792, blue: 0.443, alpha: 1), renderingMode:.alwaysOriginal), for: .normal)
        doneButton.setImage(largeBoldDone?.withTintColor(.quaternaryLabel, renderingMode:.alwaysOriginal), for: .highlighted)
        doneButton.setImage(largeBoldDone?.withTintColor(.secondaryLabel, renderingMode:.alwaysOriginal), for: .disabled)
        
        removeButton.isEnabled = false
        doneButton.isEnabled = false
    }
    
    @IBAction func toCategoriesManage() {
        performSegue(withIdentifier: "toCategoriesManage", sender: nil)
        ManageCategoriesVC.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BudgetPVC, segue.identifier == "embedWindow" {
            vc.budgetDelegate = self
        }
    }
    
    // MARK: Categories Update
    
    func updateCategories(transaction: String, name: String) {
        categoriesShown.removeAll()
        
        categories.sort(by:{ $0.sortInt > $1.sortInt})
        
        switch transaction {
        case "-":
            for el in self.categories {
                if el.type == .manage {
                    self.categoriesShown.append(el)
                }
            }
            for el in self.categories {
                if el.type == .spending {
                    self.categoriesShown.append(el)
                }
            }
            for el in self.categories {
                if el.type == .budget {
                    self.categoriesShown.append(el)
                }
            }
        case "+":
            for el in self.categories {
                if el.type == .manage {
                    self.categoriesShown.append(el)
                }
            }
            for el in self.categories {
                if el.type == .earning {
                    self.categoriesShown.append(el)
                }
            }
            for el in self.categories {
                if el.type == .budget {
                    self.categoriesShown.append(el)
                }
            }
        default: print("Incorretct transaction symbol")
        }
        
        for (index, el) in self.categoriesShown.enumerated() {
            if el.title == name {
                self.categoriesShown.remove(at: index)
            }
        }
        
        categoriesCollectionView.reloadData()
    }
    
}

// MARK:  Buttons Interaction

extension BudgetVC {
    
    @IBAction func numberOneButton(_ sender: Any) { sendAction(action: "1") }
    
    @IBAction func numberTwoButton(_ sender: Any) { sendAction(action: "2") }
    
    @IBAction func numberThreeButton(_ sender: Any) { sendAction(action: "3") }
    
    @IBAction func numberFourButton(_ sender: Any) { sendAction(action: "4") }
    
    @IBAction func numberFiveButton(_ sender: Any) { sendAction(action: "5") }
    
    @IBAction func numberSixButton(_ sender: Any) { sendAction(action: "6") }
    
    @IBAction func numberSevenButton(_ sender: Any) { sendAction(action: "7") }
    
    @IBAction func numberEightButton(_ sender: Any) { sendAction(action: "8") }
    
    @IBAction func numberNineButton(_ sender: Any) { sendAction(action: "9") }
    
    @IBAction func deleteButton(_ sender: Any) {
        sendAction(action: "-")
    }
    
    @IBAction func numberZeroButton(_ sender: Any) { sendAction(action: "0") }
    
    @IBAction func doneButton(_ sender: Any) {
        sendAction(action: "+")
    }
    
    // MARK: Delegate protocol
    
    func createTransaction(number: Float, budgetID: String) {
        
        // TODO: Transactions are added to DB here and balance of budget item changed
        
        var newTransaction: Transaction!
        
        if let indexPath = categoriesCollectionView.indexPathsForSelectedItems?.first {
            
            let cell = categoriesCollectionView.cellForItem(at: indexPath) as? CategoryCell
            
            if cell?.categoryType == CategoryType.spending {
                print("id-\(budgetID): Spent \(number) on \(cell!.titleLabel.text!)")
                newTransaction = Transaction(transactionID: UUID().uuidString, transactionAmount: number, categoryID: cell?.categoryID, date: Date(), budgetFromID: budgetID, budgetToID: nil)
            }
            else if cell?.categoryType == CategoryType.earning {
                print("id-\(budgetID): Earned \(number) from \(cell!.titleLabel.text!)")
                newTransaction = Transaction(transactionID: UUID().uuidString, transactionAmount: number, categoryID: cell?.categoryID, date: Date(), budgetFromID: budgetID, budgetToID: nil)
            }
            else if cell?.categoryType == CategoryType.budget {
                print("id-\(budgetID): Transfered \(number) from/to \(cell!.titleLabel.text!)")
                
                // TODO: Transfers
                
            }
            
        } else {
            print("id_\(budgetID): \(number) on/from smthng...")
            Transaction(transactionID: UUID().uuidString, transactionAmount: number, categoryID: nil, date: Date(), budgetFromID: budgetID, budgetToID: nil)
        }
        
        categoriesCollectionView.reloadData()
    }
    
    func sendAction(action: String) {
        BudgetVC.delegateUp?.transportUp(string: action)
    }
    
    func disableButtons() {
        removeButton.isEnabled = false
        doneButton.isEnabled = false
    }
    
    func enableButtons() {
        removeButton.isEnabled = true
        doneButton.isEnabled = true
    }
    
    func reloadCategories() {
        // TODO: Load categories from DB
        categoriesCollectionView.reloadData()
    }
}
