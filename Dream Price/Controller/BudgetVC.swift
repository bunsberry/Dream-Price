//
//  BudgetVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit
import Foundation
import RealmSwift

protocol TransportUpDelegate {
    func transportUp(string: String)
    func reloadItems()
    func refreshPageView()
}

class BudgetVC: UIViewController, BudgetDelegate, CategoriesBeenManaged {
    
    private var categories: [Category] = []
    
    public var categoriesShown: [Category] = []
    public var selectedCategoryPath: IndexPath?
    public var selectedCategoryCell: CategoryCell?

    public static var currentTransaction: String = "-"
    var currentBudgetID: String = ""
    
    public static var delegateUp: TransportUpDelegate?
    
    @IBOutlet weak var budgetsViewContainer: UIView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonsSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BudgetVC.delegateUp?.refreshPageView()
        BudgetVC.delegateUp?.reloadItems()
        updateCategories(transaction: BudgetVC.currentTransaction, id: currentBudgetID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let haveLaunched = Settings.shared.haveAlreadyLaunched {
            if haveLaunched == false {
                performSegue(withIdentifier: "toOnboarding", sender: nil)
                Settings.shared.haveAlreadyLaunched = true
            }
        }
    }
    
    // MARK: Buttons setup
    
    func buttonsSetup() {
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)

        let largeBoldDelete = UIImage(systemName: "delete.left.fill", withConfiguration: largeConfig)
        let largeBoldDone = UIImage(systemName: "checkmark.circle.fill", withConfiguration: largeConfig)
        
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
            
            if realm.objects(RealmBudget.self).count == 0 {
                let personalAccount = RealmBudget(id: UUID().uuidString, name: NSLocalizedString("Personal Account", comment: ""), balance: 0.0, type: "personal")
                let dreamAccount = RealmBudget(id: UUID().uuidString, name: NSLocalizedString("Dream", comment: ""), balance: 0.0, type: "dream")
                
                RealmService().create(personalAccount)
                RealmService().create(dreamAccount)
                
                let exampleCategory1 = RealmCategory(id: UUID().uuidString, type: "earning", title: NSLocalizedString("Work", comment: ""), sortInt: 0)
                let exampleCategory2 = RealmCategory(id: UUID().uuidString, type: "spending",  title: NSLocalizedString("Coffee", comment: ""), sortInt: 0)
                let exampleCategory3 = RealmCategory(id: UUID().uuidString, type: "spending",  title: NSLocalizedString("Groceries", comment: ""), sortInt: 1)
                
                RealmService().create(exampleCategory1)
                RealmService().create(exampleCategory2)
                RealmService().create(exampleCategory3)
                
                for (index, object) in realm.objects(RealmBudget.self).enumerated() {
                    RealmService().create(RealmCategory(id: object.id, type: "budget", title: object.name, sortInt: index))
                }
                
                let exampleDream1 = RealmDream(title: NSLocalizedString("New Phone", comment: ""),
                                              description: NSLocalizedString("Mine's a bit old now...", comment: ""),
                                              goal: 12000, type: "focusedDream", dateAdded: Date())
                let exampleDream2 = RealmDream(title: NSLocalizedString("Trip to London", comment: ""),
                                              description: NSLocalizedString("I wanna see Big Ben", comment: ""),
                                              goal: 100000, type: "dream", dateAdded: Date())
                
                RealmService().create(exampleDream1)
                RealmService().create(exampleDream2)
            }
            
            reloadCategoriesData()
            
            for object in realm.objects(RealmBudget.self) {
                if object.type == "personal" {
                    updateCategories(transaction: "-", id: object.id)
                    currentBudgetID = object.id
                }
            }
            
            vc.budgetDelegate = self
        }
    }
    
    // MARK: Categories Update
    
    func updateCategories(transaction: String, id: String) {
        
        currentBudgetID = id
        BudgetVC.currentTransaction = transaction
        
        categoriesShown.removeAll()
        categories.removeAll()
        
        reloadCategoriesData()
        
        categories.sort(by:{ $0.sortInt < $1.sortInt})
        
        switch transaction {
        case "-":
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
            for el in self.categories {
                if el.type == .manage {
                    self.categoriesShown.append(el)
                }
            }
        case "+":
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
            for el in self.categories {
                if el.type == .manage {
                    self.categoriesShown.append(el)
                }
            }
        default:
            print("switch didn't work")
        }
        
        for (index, el) in self.categoriesShown.enumerated() {
            if el.categoryID == id {
                self.categoriesShown.remove(at: index)
            }
        }
        
        selectedCategoryPath = nil
        selectedCategoryCell = nil
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
        
        if let category = selectedCategoryCell {
            
            if category.categoryType == CategoryType.spending {
                try! realm.write {
                    realm.add(RealmTransaction(id: UUID().uuidString, transactionAmount: number, categoryID: category.categoryID, date: NSDate(), fromBudget: budgetID, toBudget: nil))
                }
            }
            else if category.categoryType == CategoryType.earning {
                try! realm.write {
                    realm.add(RealmTransaction(id: UUID().uuidString, transactionAmount: number, categoryID: category.categoryID, date: NSDate(), fromBudget: budgetID, toBudget: nil))
                }
            }
            else if category.categoryType == CategoryType.budget {
                // check
                
                let budgetsRealm = realm.objects(RealmBudget.self)
                let projectsRealm = realm.objects(RealmProject.self)
                
                for object in budgetsRealm {
                    if object.id == category.categoryID {
                        try! realm.write {
                            realm.add(RealmTransaction(id: UUID().uuidString, transactionAmount: number, categoryID: category.categoryID, date: NSDate(), fromBudget: budgetID, toBudget: object.id))
                            object.balance -= number
                        }
                    }
                }
                
                for object in projectsRealm {
                    if object.id == category.categoryID {
                        try! realm.write {
                            realm.add(RealmTransaction(id: UUID().uuidString, transactionAmount: number, categoryID: category.categoryID, date: NSDate(), fromBudget: budgetID, toBudget: object.id))
                            object.balance -= number
                        }
                    }
                }
                
                BudgetVC.delegateUp?.refreshPageView()
                
            }
            
        } else {
            try! realm.write {
                realm.add(RealmTransaction(id: UUID().uuidString, transactionAmount: number, categoryID: nil, date: NSDate(), fromBudget: budgetID, toBudget: nil))
            }
        }
        
        selectedCategoryPath = nil
        selectedCategoryCell = nil
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
    
    func reloadCategoriesData() {
        for object in realm.objects(RealmCategory.self) {
            categories.append(Category(categoryID: object.id, type: CategoryType(rawValue: object.type)!, title: object.title, sortInt: object.sortInt))
        }
        
        categories.append(Category(categoryID: "", type: .manage, title: "+", sortInt: 0))
    }
    
    func categoriesBeenManaged() {
        updateCategories(transaction: BudgetVC.currentTransaction, id: currentBudgetID)
    }
    
    func forceReloadBudgets() {
        // todo: removing a page
    }
}
