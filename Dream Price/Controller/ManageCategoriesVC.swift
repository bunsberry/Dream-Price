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
    func categoriesBeenManaged()
}

class ManageCategoriesVC: UIViewController, CategoryManageDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarItem!
    
    let realm = try! Realm()
    
    var categories: [Category] = []
    var earningSection: [Category] = []
    var spendingSection: [Category] = []
    var sections: [[Category]] = []
    
    static public var delegate: CategoriesBeenManaged?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        editButton.title = NSLocalizedString("Edit", comment: "")
    }
    
    // MARK: Buttons
    
    @IBAction func save(_ sender: Any) {
        ManageCategoriesVC.delegate?.categoriesBeenManaged()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        
        if sender.title == NSLocalizedString("Edit", comment: "") {
            sender.title = NSLocalizedString("Done", comment: "")
        } else {
            sender.title = NSLocalizedString("Edit", comment: "")
            updateTableView()
        }

    }
    
    // MARK: UpdateTableView()
    
    private func updateTableView() {
        categories.removeAll()
        earningSection.removeAll()
        spendingSection.removeAll()
        sections.removeAll()
        
        let realmCategories = realm.objects(RealmCategory.self)
        
        for object in realmCategories {
            categories.append(Category(categoryID: object.id, type: CategoryType(rawValue: object.type)!, title: object.title, sortInt: object.sortInt))
        }
        
        earningSection.append(Category(categoryID: UUID().uuidString, type: .new, title: "", sortInt: 0))
        spendingSection.append(Category(categoryID: UUID().uuidString, type: .new, title: "", sortInt: 0))
        
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
        
        let newCategory = RealmCategory()
        newCategory.id = UUID().uuidString
        newCategory.title = category
        newCategory.type = type.rawValue
        
        if type == .spending {
            newCategory.sortInt = sections[0].count
            categories.append(Category(categoryID: newCategory.id, type: type, title: newCategory.title, sortInt: sections[0].count))
        } else if type == .earning {
            newCategory.sortInt = sections[1].count
            categories.append(Category(categoryID: newCategory.id, type: type, title: category, sortInt: sections[1].count))
        }
        
        RealmService().create(newCategory)
        
        updateTableView()
    }
    
    // MARK: Category Edit
    
    func categoryEdited(id: String, title: String) {
        
        for object in realm.objects(RealmCategory.self) {
            if object.id == id {
                try! realm.write {
                    object.title = title
                }
            }
        }
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
        if destinationIndexPath.row != 0 {
            var movedObj = sections[sourceIndexPath.section][sourceIndexPath.row]
            
            if movedObj.sortInt < sections[destinationIndexPath.section][destinationIndexPath.row].sortInt {
                
                for (index, el) in sections[destinationIndexPath.section].enumerated() {
                    if el.sortInt > movedObj.sortInt {
                        sections[destinationIndexPath.section][index].sortInt -= 1
                    }
                    
                    for (index1, category) in categories.enumerated() {
                        if category.categoryID == sections[destinationIndexPath.section][index].categoryID {
                            categories[index1].sortInt = sections[destinationIndexPath.section][index].sortInt
                        }
                    }
                }
                movedObj.sortInt = destinationIndexPath.row
                
                for (index, category) in categories.enumerated() {
                    if movedObj.categoryID == category.categoryID {
                        categories[index].sortInt = movedObj.sortInt
                    }
                }
                
                try! realm.write {
                    for object in realm.objects(RealmCategory.self) {
                        realm.delete(object)
                    }
                }
                
                for category in categories {
                    RealmService().create(RealmCategory(id: category.categoryID, type: category.type.rawValue, title: category.title, sortInt: category.sortInt))
                }
                
            } else if movedObj.sortInt > sections[destinationIndexPath.section][destinationIndexPath.row].sortInt {
                
                for (index, el) in sections[destinationIndexPath.section].enumerated() {
                    if el.sortInt < movedObj.sortInt {
                        sections[destinationIndexPath.section][index].sortInt += 1
                    }
                    
                    for (index1, category) in categories.enumerated() {
                        if category.categoryID == sections[destinationIndexPath.section][index].categoryID {
                            categories[index1].sortInt = sections[destinationIndexPath.section][index].sortInt
                        }
                    }
                }
                
                movedObj.sortInt = destinationIndexPath.row
                
                for (index, category) in categories.enumerated() {
                    if movedObj.categoryID == category.categoryID {
                        categories[index].sortInt = movedObj.sortInt
                    }
                }
                
                try! realm.write {
                    for object in realm.objects(RealmCategory.self) {
                        realm.delete(object)
                    }
                }
                
                for category in categories {
                    RealmService().create(RealmCategory(id: category.categoryID, type: category.type.rawValue, title: category.title, sortInt: category.sortInt))
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
        
        if editingStyle == .delete {
            
            for (index, category) in categories.enumerated() {
                if category.categoryID == sections[indexPath.section][indexPath.row].categoryID {
                    categories.remove(at: index)
                    
                    for object in realm.objects(RealmCategory.self) {
                        if object.id == category.categoryID {
                            try! realm.write {
                                realm.delete(object)
                            }
                        }
                    }
                }
            }
            
            sections[indexPath.section].remove(at: indexPath.row)
            
            for (index, category) in sections[indexPath.section].enumerated() {
                sections[indexPath.section][index].sortInt = index
                
                if category.categoryID != "-1" {
                    
                    for (index1, category) in categories.enumerated() {
                        if category.categoryID == sections[indexPath.section][index].categoryID {
                            categories[index1].sortInt = index
                            
                            for object in realm.objects(RealmCategory.self) {
                                if object.id == category.categoryID {
                                    try! realm.write {
                                        object.sortInt = index
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            updateTableView()
        }
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
            cell.id = sections[indexPath.section][indexPath.row].categoryID
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
