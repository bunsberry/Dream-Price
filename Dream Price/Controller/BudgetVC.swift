//
//  BudgetVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit

protocol TransportUpDelegate {
    func transportUp(string: String)
}

class BudgetVC: UIViewController, CategoriesDelegate {
    
    let categories: [Category] = [
        Category(type: .earning, title: "💼 Работа"),
        Category(type: .spendind, title: "☕️ Кофе"),
        Category(type: .spendind, title: "🥑 Продукты"),
        Category(type: .budget, title: "📱 Приложуха"),
        Category(type: .budget, title: "🌙 Мечта"),
        Category(type: .manage, title: "Изменить...")
    ]
    
    var categoriesShown: [Category] = []

    public static var currentTransaction: String = "-"
    
    public static var delegateUp: TransportUpDelegate?
    
    @IBOutlet weak var budgetsViewContainer: UIView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCategories(transaction: "-")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BudgetPVC, segue.identifier == "embedWindow" {
            vc.categoriesDelegate = self
        }
    }
    
    func updateCategories(transaction: String) {
        categoriesShown.removeAll()
        
        switch transaction {
        case "-": do {
                for el in self.categories {
                    if el.type != .earning {
                        self.categoriesShown.append(el)
                    }
                }
            }
            case "+": do {
                for el in self.categories {
                    if el.type != .spendind {
                        self.categoriesShown.append(el)
                    }
                }
            }
            default: break
        }
        
        categoriesCollectionView.reloadData()
    }
    
}

// MARKS:  Buttons Interaction

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
        // TODO: Button States
        sendAction(action: "-")
    }
    
    @IBAction func numberZeroButton(_ sender: Any) { sendAction(action: "0") }
    
    @IBAction func doneButton(_ sender: Any) {
        // TODO: Category Deselect
        // TODO: Button States
        sendAction(action: "+")
    }
    
    func sendAction(action: String) {
        BudgetVC.delegateUp?.transportUp(string: action)
    }
}
