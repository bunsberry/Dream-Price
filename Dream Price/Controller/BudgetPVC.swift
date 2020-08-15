//
//  BudgetPVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit
import RealmSwift

protocol BudgetDelegate {
    func updateCategories(transaction: String, id: String)
    func createTransaction(number: Float, budgetID: String)
    func disableButtons()
    func enableButtons()
}

protocol KeyboardDelegate {
    func updateTransaction(action: String)
    func reloadItems()
}

class BudgetPVC: UIPageViewController, TransportDelegate, TransportUpDelegate {
    
    let realm = try! Realm()
    
    var pagesData: [BudgetItem] = []
    
    var budgetDelegate: BudgetDelegate?
    var keyboardDelegate: KeyboardDelegate?
    
    var currentIndex: Int = 0
    var starterIndex: Int = 0
    
    var appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appearance.pageIndicatorTintColor = UIColor.secondaryLabel
        appearance.currentPageIndicatorTintColor = UIColor.label
        
        let realmBudgets = realm.objects(RealmBudget.self)
        
        for budget in realmBudgets {
            pagesData.append(BudgetItem(budgetID: budget.id, type: BudgetItemType(rawValue: budget.type)!, balance: Float(budget.balance), name: budget.name))
        }
        
        self.dataSource = self
        self.delegate = self
        
        BudgetItemDataVC.delegate = self
        BudgetVC.delegateUp = self
        
        for (index, page) in pagesData.enumerated() {
            if page.type == .personal {
                starterIndex = index
            }
        }
        
        if let vc = self.pageViewController(for: starterIndex) {
            self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
            keyboardDelegate = vc
        }
    }
    
    // MARK: Delegate protocol
    
    func transportCurrentState(symbol: String, id: String) {
        budgetDelegate?.updateCategories(transaction: symbol, id: id)
    }
    
    func transportTransactionData(number: Float, budgetID: String) {
        budgetDelegate?.createTransaction(number: number, budgetID: budgetID)
    }
    
    func transportButtons(enabled: Int) {
        if enabled == 0 {
            budgetDelegate?.disableButtons()
        } else {
            budgetDelegate?.enableButtons()
        }
    }
    
    func transportUp(string: String) {
        keyboardDelegate?.updateTransaction(action: string)
    }
    
    func reloadItems() {
        keyboardDelegate?.reloadItems()
    }
    
    // MARK: Page View
    
    func pageViewController(for index: Int) -> BudgetItemDataVC? {
        if index < 0 || index >= pagesData.count {
            return nil
        }
        let vc = (storyboard?.instantiateViewController(withIdentifier: "BudgetItemDataVC") as! BudgetItemDataVC)
        
        vc.balance = pagesData[index].balance
        vc.nameLabelText = pagesData[index].name
        vc.budgetItemType = pagesData[index].type
        vc.index = index
        vc.budgetID = pagesData[index].budgetID
        
        self.currentIndex = index
        
        return vc
    }

}

extension BudgetPVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pagesData.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = ((viewController as? BudgetItemDataVC)?.index ?? 0) - 1
        
        DispatchQueue.main.async {
            self.keyboardDelegate = viewController as? BudgetItemDataVC
            
            if (viewController as? BudgetItemDataVC)?.transactionLabel.text == "0"  || (viewController as? BudgetItemDataVC)?.transactionLabel.text == "0.00" {
                self.transportButtons(enabled: 0)
            } else {
                self.transportButtons(enabled: 1)
            }
            
            self.transportCurrentState(symbol: ((viewController as? BudgetItemDataVC)?.changeTransactionButton.title(for: .normal))!, id: ((viewController as? BudgetItemDataVC)?.budgetID)!)
        }
        
        return self.pageViewController(for: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = ((viewController as? BudgetItemDataVC)?.index ?? 0) + 1
        
        DispatchQueue.main.async {
            self.keyboardDelegate = viewController as? BudgetItemDataVC
            
            if (viewController as? BudgetItemDataVC)?.transactionLabel.text == "0" || (viewController as? BudgetItemDataVC)?.transactionLabel.text == "0.00" {
                self.transportButtons(enabled: 0)
            } else {
                self.transportButtons(enabled: 1)
            }
            
            self.transportCurrentState(symbol: ((viewController as? BudgetItemDataVC)?.changeTransactionButton.title(for: .normal))!, id: ((viewController as? BudgetItemDataVC)?.budgetID)!)
        }
        
        return self.pageViewController(for: index)
    }
    
}
