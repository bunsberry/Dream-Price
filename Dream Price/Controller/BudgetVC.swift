//
//  BudgetVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit

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
        print("Started updating categories")
        
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
        print("Categories Reloaded")
    }

}
