//
//  BudgetPVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit

protocol CategoriesDelegate {
    func updateCategories(transaction: String)
}

class BudgetPVC: UIPageViewController, TransportDelegate {
    
    let pagesData: [BudgetItem] = [
        BudgetItem(type: .project, balance: 25, name: "Проект 1"),
        BudgetItem(type: .project, balance: 12, name: "Проект"),
        BudgetItem(type: .personal, balance: 25680, name: "Личный Счёт"),
        BudgetItem(type: .dream, balance: 23000, name: "Мечта")
    ]
    
    var categoriesDelegate: CategoriesDelegate?
    
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
        
        for (index, page) in pagesData.enumerated() {
            if page.type == .personal {
                starterIndex = index
            }
        }
        
        if let vc = self.pageViewController(for: starterIndex) {
            self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func transport(string: String) {
        categoriesDelegate?.updateCategories(transaction: string)
    }
    
    func pageViewController(for index: Int) -> BudgetItemDataVC? {
        if index < 0 || index >= pagesData.count {
            return nil
        }
        let vc = (storyboard?.instantiateViewController(withIdentifier: "BudgetItemDataVC") as! BudgetItemDataVC)
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.init(identifier: "ru_RU")
        
        let intSettingIsSet = true
        if intSettingIsSet {
            // TODO В зависимости от настроек передается Int или Float
            let balance: Int = Int(pagesData[index].balance.rounded())
            currencyFormatter.maximumFractionDigits = 0
            currencyFormatter.minimumFractionDigits = 0
            let priceString = currencyFormatter.string(from: NSNumber(value: balance))!
            vc.balanceLabelText = "Баланс: \(priceString)"

        } else {
            let balance: Float = pagesData[index].balance
            let priceString = currencyFormatter.string(from: NSNumber(value: balance))!
            vc.balanceLabelText = "Баланс: \(priceString)"
        }
        
        vc.nameLabelText = pagesData[index].name
        vc.budgetItemType = pagesData[index].type
        vc.index = index
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
        
        return self.pageViewController(for: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = ((viewController as? BudgetItemDataVC)?.index ?? 0) + 1
        
        return self.pageViewController(for: index)
    }
    
}
