//
//  BudgetPVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit

protocol BudgetDelegate {
    func updateCategories(transaction: String)
    func createTransaction(number: Float, budgetID: Int)
    func disableButtons()
    func enableButtons()
}

protocol KeyboardDelegate {
    func updateTransaction(action: String)
}

class BudgetPVC: UIPageViewController, TransportDelegate, TransportUpDelegate {
    
    // TODO: Getting budgetItems from DB here
    
    let pagesData: [BudgetItem] = [
        BudgetItem(id: 3, type: .project, balance: 25, name: "Проект 1"),
        BudgetItem(id: 2, type: .project, balance: 12, name: "Проект"),
        BudgetItem(id: 0, type: .personal, balance: 25680, name: "Личный Счёт"),
        BudgetItem(id: 1, type: .dream, balance: 23000, name: "Мечта")
    ]
    
    var budgetDelegate: BudgetDelegate?
    var keyboardDelegate: KeyboardDelegate?
    
    var currentIndex: Int = 0
    var starterIndex: Int = 0
    
    var appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appearance.pageIndicatorTintColor = UIColor.secondaryLabel
        appearance.currentPageIndicatorTintColor = UIColor.label

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
    
    func transportCurrentState(string: String) {
        budgetDelegate?.updateCategories(transaction: string)
    }
    
    func transportTransactionData(number: Float, budgetID: Int) {
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
        vc.id = pagesData[index].id
        
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
            self.transportCurrentState(string: ((viewController as? BudgetItemDataVC)?.changeTransactionButton.title(for: .normal))!)
        }
        
        return self.pageViewController(for: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = ((viewController as? BudgetItemDataVC)?.index ?? 0) + 1
        
        DispatchQueue.main.async {
            self.keyboardDelegate = viewController as? BudgetItemDataVC
            self.transportCurrentState(string: ((viewController as? BudgetItemDataVC)?.changeTransactionButton.title(for: .normal))!)
        }
        
        return self.pageViewController(for: index)
    }
    
}
