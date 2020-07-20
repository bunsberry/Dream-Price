//
//  ManageCategoriesVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 15.07.2020.
//

import UIKit

protocol NewCategoryDelegate {
    func addNewCategory(category: String, type: CategoryType)
}

class ManageCategoriesVC: UIViewController, NewCategoryDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // TODO: Read categories from DB
    
    var categories: [Category] = [
        Category(id: 0, type: .earning, title: NSLocalizedString("Work", comment: "")),
        Category(id: 0, type: .spending, title: NSLocalizedString("Coffee", comment: "")),
        Category(id: 1, type: .spending, title: NSLocalizedString("Groceries", comment: "")),
        Category(id: 0, type: .budget, title: NSLocalizedString("App", comment: "")),
        Category(id: 1, type: .budget, title: NSLocalizedString("Dream", comment: "")),
        Category(id: 0, type: .manage, title: NSLocalizedString("More...", comment: ""))
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
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        
        if sender.title == NSLocalizedString("Edit", comment: "") {
            sender.title = NSLocalizedString("Done", comment: "")
        } else {
            sender.title = NSLocalizedString("Done", comment: "")
        }
        
        self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0))?.showsReorderControl = false
        self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 1))?.showsReorderControl = false
    }
    
    private func updateTableView() {
        earningSection.removeAll()
        spendingSection.removeAll()
        sections.removeAll()
        
        earningSection.append(Category(id: 0, type: .new, title: ""))
        spendingSection.append(Category(id: 0, type: .new, title: ""))
        
        for el in categories {
            if el.type == .earning {
                earningSection.append(el)
            } else if el.type == .spending {
                spendingSection.append(el)
            }
        }
        
        sections = [spendingSection, earningSection]
        tableView.reloadData()
    }
    
    func addNewCategory(category: String, type: CategoryType) {
        categories.append(Category(id: categories.count, type: type, title: category))
        updateTableView()
        print("added new category")
    }
    
}

extension ManageCategoriesVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // TODO: DB Object moved to another position
        
        let movedObj = sections[sourceIndexPath.section][sourceIndexPath.row]
        sections[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        sections[sourceIndexPath.section].insert(movedObj, at: destinationIndexPath.row)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // TODO: DB Object deleted
        
        if editingStyle == .delete {
            sections[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0))?.showsReorderControl = false
            self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 1))?.showsReorderControl = false
        }
    }
    
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
}
