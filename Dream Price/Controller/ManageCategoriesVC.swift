//
//  ManageCategoriesVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 15.07.2020.
//

import UIKit
import RealmSwift

protocol CategoryManageDelegate {
    func addNewCategory(category: String, type: CategoryType)
    func categoryEdited(id: String, title: String)
}

protocol CategoriesBeenManaged {
    func reloadCategories()
}

class ManageCategoriesVC: UIViewController, CategoryManageDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarItem!
    
    // TODO: Read categories from DB - DONE
    
    var earningSection: [RealmCategory] = []
    var spendingSection: [RealmCategory] = []
    var sections: [[RealmCategory]] = []
    static public var delegate: CategoriesBeenManaged?
    
    let realm = RealmService.instance.realm

    var categories: Results<RealmCategory>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.editButton.title = NSLocalizedString("Edit", comment: "")
        
        updateCategories()
    }
    
    func updateCategories() {
        // categories = realm.objects(RealmCategory.self)
        categories = realm.objects(RealmCategory.self)
        self.updateTableView()
    }
    
    // MARK: Buttons
    
    @IBAction func cancel(_ sender: Any) {
        print("button pressed")
        ManageCategoriesVC.delegate?.reloadCategories()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        
        if sender.title == NSLocalizedString("Edit", comment: "") {
            sender.title = NSLocalizedString("Done", comment: "")
        } else {
            sender.title = NSLocalizedString("Edit", comment: "")
        }

    }
    
    // MARK: UpdateTableView()
    
    private func updateTableView() {
        earningSection.removeAll()
        spendingSection.removeAll()
        sections.removeAll()
        
        for el in categories {
            if el.type == CategoryType.earning.rawValue {
                earningSection.append(el)
            } else if el.type == CategoryType.spending.rawValue {
                spendingSection.append(el)
            }
        }
        earningSection.sort(by:{ $0.sortInt! < $1.sortInt! })
        spendingSection.sort(by:{ $0.sortInt! < $1.sortInt! })
        
        sections = [spendingSection, earningSection]
        tableView.reloadData()
    }
    
    // MARK: Adding new Category
    
    func addNewCategory(category: String, type: CategoryType) {
        
        // TODO: New Category Added to DB - DONE
        
        if type == .spending {
            print(Category(id: UUID().uuidString, type: type, title: category, sortInt: sections[0].count))
            let newCategory = RealmCategory(id: UUID().uuidString, title: category, type: type.rawValue, sortInt: sections[0].count)
            RealmService.instance.create(newCategory)
        } else if type == .earning {
            print(Category(id: UUID().uuidString, type: type, title: category, sortInt: sections[1].count))
            let newCategory = RealmCategory(id: UUID().uuidString, title: category, type: type.rawValue, sortInt: sections[1].count)
            RealmService.instance.create(newCategory)
            
        }
        updateCategories()
    }
    
    // MARK: Category Edit
    
    func categoryEdited(id: String, title: String) {
        
        // TODO: DB Category title changed - DONE
        
        for (index, category) in categories.enumerated() {
            if category.id == id {
                try! realm.write {
                    categories[index].title = title
                }
                print(categories[index])
            }
        }
        updateCategories()
    }
    
}

// MARK: Table View

extension ManageCategoriesVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    // MARK: Deleting
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // TODO: DB Object deleted - DONE
        if editingStyle == .delete {
            RealmService.instance.delete(categories[indexPath.row])
            updateCategories()
        }
        print("Category Deleted")
    }
    
    // MARK: Table View Data Source and Delegate
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath == IndexPath.init(row: 0, section: 0) || indexPath == IndexPath.init(row: 0, section: 1) {
            return .none
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sections[indexPath.section][indexPath.row].type == CategoryType.new.rawValue {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "newCategoryCell", for: indexPath) as! NewCategoryCell
                
                cell.setEditing(false, animated: true)
                cell.delegate = self
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "newEarningCell", for: indexPath) as! NewEarningCell
                
                cell.setEditing(false, animated: true)
                cell.delegate = self
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! EditableCategoryCell
            
            cell.titleTextField?.text = sections[indexPath.section][indexPath.row].title
            cell.id = sections[indexPath.section][indexPath.row].id
            cell.firstTitle = sections[indexPath.section][indexPath.row].title
            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("Spendings", comment: "")
        } else {
            return NSLocalizedString("Earnings", comment: "")
        }
    }
    
    func tableView (_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row > 0 {
            return true
        }
        return false
    }
}
