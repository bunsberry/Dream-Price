//
//  ManageCategoriesVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 15.07.2020.
//

import UIKit

protocol CategoryManageDelegate {
    func addNewCategory(category: String, type: CategoryType)
    func categoryEdited(id: String, title: String)
}

class ManageCategoriesVC: UIViewController, CategoryManageDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarItem!
    
    // TODO: Read categories from DB
    
    var categories: [Category] = [
        Category(id: "a", type: .earning, title: NSLocalizedString("Work", comment: ""), sortInt: 1),
        Category(id: "b", type: .earning, title: NSLocalizedString("Work", comment: ""), sortInt: 3),
        Category(id: "c", type: .earning, title: "Side Gig", sortInt: 2),
        Category(id: "d", type: .spending, title: NSLocalizedString("Coffee", comment: ""), sortInt: 1),
        Category(id: "g", type: .spending, title: NSLocalizedString("Groceries", comment: ""), sortInt: 2)
    ] {
        didSet { tableView.reloadData() }
    }
    
    var earningSection: [Category] = []
    var spendingSection: [Category] = []
    var sections: [[Category]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        editButton.title = NSLocalizedString("Edit", comment: "")
    }
    
    // MARK: Buttons
    
    @IBAction func cancel(_ sender: Any) {
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
        
        earningSection.append(Category(id: "0", type: .new, title: "", sortInt: 0))
        spendingSection.append(Category(id: "0", type: .new, title: "", sortInt: 0))
        
        for el in categories {
            if el.type == .earning {
                earningSection.append(el)
            } else if el.type == .spending {
                spendingSection.append(el)
            }
        }
        
        earningSection.sort(by:{ $0.sortInt < $1.sortInt })
        spendingSection.sort(by:{ $0.sortInt < $1.sortInt })
        
        sections = [spendingSection, earningSection]
        tableView.reloadData()
    }
    
    // MARK: Adding new Category
    
    func addNewCategory(category: String, type: CategoryType) {
        
        // TODO: New Category Added to DB
        
        if type == .spending {
            print(Category(id: String(categories.count), type: type, title: category, sortInt: sections[0].count))
            categories.append(Category(id: String(categories.count), type: type, title: category, sortInt: sections[0].count))
        } else if type == .earning {
            print(Category(id: String(categories.count), type: type, title: category, sortInt: sections[1].count))
            categories.append(Category(id: String(categories.count), type: type, title: category, sortInt: sections[1].count))
        }
        
        updateTableView()
        
        
        print("added new category")
    }
    
    // MARK: Category Edit
    
    func categoryEdited(id: String, title: String) {
        
        // TODO: DB Category title changed
        
        for (index, category) in categories.enumerated() {
            if category.id == id {
                categories[index].title = title
                print(categories[index])
            }
        }
        
        updateTableView()
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
    
    // MARK: Sorting
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // TODO: DB Object moved to another position
        if destinationIndexPath.row != 0 {
            var movedObj = sections[sourceIndexPath.section][sourceIndexPath.row]
            
            if movedObj.sortInt < sections[destinationIndexPath.section][destinationIndexPath.row].sortInt {
                
                for (index, el) in sections[destinationIndexPath.section].enumerated() {
                    if el.sortInt > movedObj.sortInt {
                        sections[destinationIndexPath.section][index].sortInt -= 1
                    }
                    
                    for (index1, category) in categories.enumerated() {
                        if category.id == sections[destinationIndexPath.section][index].id {
                            categories[index1].sortInt = sections[destinationIndexPath.section][index].sortInt
                            print(categories[index1])
                        }
                    }
                }
                movedObj.sortInt = destinationIndexPath.row
                
                for (index, category) in categories.enumerated() {
                    if movedObj.id == category.id {
                        categories[index].sortInt = movedObj.sortInt
                    }
                }
            } else if movedObj.sortInt > sections[destinationIndexPath.section][destinationIndexPath.row].sortInt {
                for (index, el) in sections[destinationIndexPath.section].enumerated() {
                    if el.sortInt < movedObj.sortInt {
                        sections[destinationIndexPath.section][index].sortInt += 1
                    }
                    
                    for (index1, category) in categories.enumerated() {
                        if category.id == sections[destinationIndexPath.section][index].id {
                            categories[index1].sortInt = sections[destinationIndexPath.section][index].sortInt
                            print(categories[index1])
                        }
                    }
                }
                
                movedObj.sortInt = destinationIndexPath.row
                
                for (index, category) in categories.enumerated() {
                    if movedObj.id == category.id {
                        categories[index].sortInt = movedObj.sortInt
                    }
                }
            }
            
            sections[sourceIndexPath.section].remove(at: sourceIndexPath.row)
            sections[sourceIndexPath.section].insert(movedObj, at: destinationIndexPath.row)
        } else {
            updateTableView()
        }
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
        
        // TODO: DB Object deleted
        
        if editingStyle == .delete {
            
            for (index, category) in categories.enumerated() {
                if category.id == sections[indexPath.section][indexPath.row].id {
                    categories.remove(at: index)
                }
            }
            
            sections[indexPath.section].remove(at: indexPath.row)
            
            for (index, category) in sections[indexPath.section].enumerated() {
                sections[indexPath.section][index].sortInt = index
                
                if category.id != "-1" {
                    
                    for (index1, category) in categories.enumerated() {
                        if category.id == sections[indexPath.section][index].id {
                            categories[index1].sortInt = index
                        }
                    }
                }
            }
            
            updateTableView()
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
        if sections[indexPath.section][indexPath.row].type == .new {
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
