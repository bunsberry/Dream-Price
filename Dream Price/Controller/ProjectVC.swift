//
//  ProjectVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 26.08.2020.
//

import UIKit
import RealmSwift

class ProjectVC: UIViewController, UITextViewDelegate, ProjectEditDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    var isNewProject: Bool!
    var projectID: String!
    var isBudget: Bool = false
    var projectObject = Project()
    
    var actions: [Action] = []
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isNewProject == true {
            titleTextView.text = "Title"
            detailsTextView.text = "Description..."
            titleTextView.textColor = .tertiaryLabel
            detailsTextView.textColor = .tertiaryLabel
            doneButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        } else {
            projectObject.id = projectID
            
            let projects = realm.objects(RealmProject.self)
            for project in projects {
                if project.id == projectObject.id {
                    projectObject = Project(id: projectObject.id, name: project.name, details: project.details,
                                            isFinished: project.isFinished, isBudget: project.isBudget,
                                            budget: project.budget, balance: project.balance,
                                            dateFinished: project.dateFinished as Date?)
                }
            }
            
            print(projectObject)
            
            titleTextView.text = projectObject.name
            if projectObject.details == "" {
                detailsTextView.text = "Description..."
                detailsTextView.textColor = .tertiaryLabel
            } else {
                detailsTextView.text = projectObject.details
                detailsTextView.textColor = .label
            }
            
            doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        }
        
        titleTextView.delegate = self
        detailsTextView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @IBAction func done(_ sender: UIButton) {
        
        // technicaly i need only color but i guess it's okay to double check
        if titleTextView.text == "" || titleTextView.textColor == .tertiaryLabel {
            // Alert
            let alert = UIAlertController(title: NSLocalizedString("Fill in all the required information", comment: ""),
                                          message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        } else {
            if isNewProject {
                // Save
                if projectObject.isBudget {
                    let budgetCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ProjectBudbetCell
                    
                    if budgetCell.budgetTextField.text != "" {
                        
                        isNewProject = false
                        
                        projectObject.name = titleTextView.text
                        if detailsTextView.textColor != UIColor.tertiaryLabel { projectObject.details = detailsTextView.text }
                        
                        tableView.beginUpdates()
                        tableView.reloadRows(at: [IndexPath(row: 0, section: 0),
                                                  IndexPath(row: 1, section: 0)], with: .automatic)
                        tableView.insertRows(at: [IndexPath(row: 2, section: 0),
                                                  IndexPath(row: 3, section: 0)], with: .automatic)
                        tableView.endUpdates()
                            
                        doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
                        
                        let newProject = RealmProject(name: projectObject.name, details: projectObject.details, isBudget: projectObject.isBudget, budget: projectObject.budget)
                        newProject.id = projectObject.id
                        
                        try! realm.write {
                            realm.add(newProject)
                        }
                    } else {
                        // Alert
                        let alert = UIAlertController(title: NSLocalizedString("Fill in all the required information", comment: ""),
                                                      message: nil, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: nil))
                        
                        present(alert, animated: true, completion: nil)
                    }
                } else {
                    isNewProject = false
                    
                    projectObject.name = titleTextView.text
                    if detailsTextView.textColor != UIColor.tertiaryLabel { projectObject.details = detailsTextView.text }
                    
                    tableView.beginUpdates()
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    tableView.insertRows(at: [IndexPath(row: 1, section: 0),
                                              IndexPath(row: 2, section: 0)], with: .automatic)
                    tableView.endUpdates()
                        
                    doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
                    
                    let newProject = RealmProject(name: projectObject.name, details: projectObject.details, isBudget: projectObject.isBudget, budget: projectObject.budget)
                    newProject.id = projectObject.id
                    try! realm.write {
                        realm.add(newProject)
                    }
                }
            } else {
                print("done pressed")
                // Done
                projectObject.name = titleTextView.text
                if detailsTextView.textColor != UIColor.tertiaryLabel {
                    projectObject.details = detailsTextView.text
                } else { projectObject.details = "" }
                
                let projects = realm.objects(RealmProject.self)
                for project in projects {
                    if project.id == projectObject.id {
                        print("found da shit")
                        try! realm.write {
                            project.name = projectObject.name
                            project.details = projectObject.details
                            project.isBudget = projectObject.isBudget
                        }
                    }
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func moreOptions(_ sender: UIButton) {
        let moreOptionsMenu = UIAlertController(title: NSLocalizedString("Project Options", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let finishAction = UIAlertAction(title: NSLocalizedString("Finish Project", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let finishMenu = UIAlertController(title: NSLocalizedString("Are you sure?", comment: ""), message: nil, preferredStyle: .alert)
            
            let yes = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                // TODO: finish project and delegating
                self.dismiss(animated: true, completion: nil)
            })
            let no = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default, handler: nil)
            
            finishMenu.addAction(no)
            finishMenu.addAction(yes)
            
            self.present(finishMenu, animated: true, completion: nil)
        })
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete Project", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let deleteMenu = UIAlertController(title: NSLocalizedString("Are you sure?", comment: ""), message: nil, preferredStyle: .alert)
            
            let yes = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                // TODO: delete project and delegating
                self.dismiss(animated: true, completion: nil)
            })
            let no = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default, handler: nil)
            
            deleteMenu.addAction(no)
            deleteMenu.addAction(yes)
            
            self.present(deleteMenu, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        moreOptionsMenu.addAction(finishAction)
        moreOptionsMenu.addAction(deleteAction)
        moreOptionsMenu.addAction(cancelAction)
        
        self.present(moreOptionsMenu, animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        if textField.textColor == .tertiaryLabel {
            textField.text = nil
            textField.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.text.isEmpty {
                textView.text = "Title"
                textView.textColor = .tertiaryLabel
            }
        } else {
            if textView.text.isEmpty {
                textView.text = "Description..."
                textView.textColor = .tertiaryLabel
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            // project title saving
        } else {
            // project description saving
        }
    }
    
    func addAction() {
        // TODO: db creating action
        if actions.count == 0 {
            actions.append(Action(id: UUID().uuidString, projectID: projectID, text: "", isCompleted: false, dateCompleted: nil))
            
            tableView.separatorStyle = .singleLine
            
            var cell = ActionCell()
            
            if projectObject.isBudget {
                tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                cell = tableView.cellForRow(at: IndexPath(row: actions.count + 1, section: 0)) as! ActionCell
            } else {
                tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                cell = tableView.cellForRow(at: IndexPath(row: actions.count, section: 0)) as! ActionCell
            }
            
            cell.taskTextView.becomeFirstResponder()
        } else {
            actions.append(Action(id: UUID().uuidString, projectID: projectID, text: "", isCompleted: false, dateCompleted: nil))
            
            var cell = ActionCell()
            
            if projectObject.isBudget {
                tableView.insertRows(at: [IndexPath(row: actions.count + 1, section: 0)], with: .automatic)
                cell = tableView.cellForRow(at: IndexPath(row: actions.count + 1, section: 0)) as! ActionCell
            } else {
                tableView.insertRows(at: [IndexPath(row: actions.count, section: 0)], with: .automatic)
                cell = tableView.cellForRow(at: IndexPath(row: actions.count, section: 0)) as! ActionCell
            }
            
            cell.taskTextView.becomeFirstResponder()
        }
    }
    
    func deleteAction(id: String) {
        for (index, action) in actions.enumerated() {
            if action.id == id {
                actions.remove(at: index)
                if actions.count == 0 {
                    if projectObject.isBudget {
                        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                    } else {
                        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                    }
                } else {
                    if projectObject.isBudget {
                        tableView.deleteRows(at: [IndexPath(row: index + 2, section: 0)], with: .automatic)
                    } else {
                        tableView.deleteRows(at: [IndexPath(row: index + 1, section: 0)], with: .automatic)
                    }
                }
            }
        }
    }
    
    func isBudgetChangedTo(_ state: Bool) {
        projectObject.isBudget = state
        
        if doneButton.title(for: .normal) == NSLocalizedString("Save", comment: "") {
            if state {
                tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            } else {
                tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
        } else {
            if state {
                tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            } else {
                tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
        }
    }
    
    func budgetNumChangedTo(_ num: Float) {
        projectObject.budget = num
        projectObject.balance = num
    }
}

extension ProjectVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isNewProject {
            // Создание проекта
            if projectObject.isBudget {
                return 2
            } else {
                return 1
            }
        } else {
            // Открытие существующего проекта
            if projectObject.isBudget {
                if actions.count == 0 {
                    tableView.separatorStyle = .none
                    return 4
                } else {
                    return actions.count + 3
                }
            } else {
                if actions.count == 0 {
                    tableView.separatorStyle = .none
                    return 3
                } else {
                    return actions.count + 2
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isNewProject {
            // New project cell
            if projectObject.isBudget {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "isBudgetCell") as! ProjectIsBudbetCell
                    
                    cell.isBudgetSwitch.isOn = projectObject.isBudget
                    cell.delegate = self
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "budgetCell") as! ProjectBudbetCell
                    
                    cell.delegate = self
                    
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "isBudgetCell") as! ProjectIsBudbetCell
                
                cell.isBudgetSwitch.isOn = projectObject.isBudget
                cell.delegate = self
                
                return cell
            }
        } else {
            // Saved project cells
            if actions.count != 0 {
                if projectObject.isBudget {
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "isBudgetCell") as! ProjectIsBudbetCell
                        
                        cell.delegate = self
                        cell.isBudgetSwitch.isOn = projectObject.isBudget
                        
                        return cell
                    } else if indexPath.row == 1 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "profitCell") as! ProjectProfitCell
                        
                        let formatter = NumberFormatter()
                        formatter.numberStyle = NumberFormatter.Style.currency
                        formatter.currencySymbol = ""
                        formatter.locale = Locale.current
                        
                        if Settings.shared.recordCentsOn! {
                            formatter.minimumFractionDigits = 2
                            formatter.maximumFractionDigits = 2
                        } else {
                            formatter.minimumFractionDigits = 0
                            formatter.maximumFractionDigits = 0
                        }
                        
                        let profit = projectObject.budget - projectObject.balance
                        if profit > 0 {
                            cell.profitView.backgroundColor = .green
                            cell.profitLabel.text = "+\(formatter.string(from: NSNumber(value: profit)))"
                        } else if profit < 0 {
                            cell.profitView.backgroundColor = .red
                            cell.profitLabel.text = formatter.string(from: NSNumber(value: profit))
                        } else {
                            cell.profitView.backgroundColor = .tertiaryLabel
                            cell.profitLabel.text = formatter.string(from: NSNumber(value: 0))
                        }
                        
                        cell.profitView.layer.cornerRadius = cell.profitView.frame.height / 4
                        
                        if let localeIdentifier = Settings.shared.chosenLocaleIdentifier {
                            cell.profitCurrencyLabel.text = " \(String(describing: Locale.init(identifier: localeIdentifier).currencySymbol!))"
                        } else {
                            if var localeCurrency = Locale.current.currencySymbol {
                                if localeCurrency == "RUB" { localeCurrency = "₽" }
                                cell.profitCurrencyLabel.text = " \(localeCurrency)"
                            }
                        }
                        
                        return cell
                    } else if indexPath.row == actions.count + 2 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "addActionCell") as! AddActionCell
                        cell.delegate = self
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell") as! ActionCell
                        
                        cell.checkmarkButton.isSelected = actions[indexPath.row - 2].isCompleted
                        if actions[indexPath.row - 2].text.isEmpty {
                            cell.taskTextView.textColor = .tertiaryLabel
                            cell.taskTextView.text = "Type task here..."
                        } else {
                            cell.taskTextView.textColor = .label
                            cell.taskTextView.text = actions[indexPath.row - 2].text
                        }
                        
                        cell.actionID = actions[indexPath.row - 2].id
                        cell.delegate = self
                        
                        cell.textDidChange = {
                            self.tableView.beginUpdates()
                            self.tableView.endUpdates()
                        }
                        
                        return cell
                    }
                } else {
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "isBudgetCell") as! ProjectIsBudbetCell
                        
                        cell.delegate = self
                        cell.isBudgetSwitch.isOn = projectObject.isBudget
                        
                        return cell
                    } else if indexPath.row == actions.count + 1 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "addActionCell") as! AddActionCell
                        cell.delegate = self
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell") as! ActionCell
                        
                        cell.checkmarkButton.isSelected = actions[indexPath.row - 1].isCompleted
                        if actions[indexPath.row - 1].text.isEmpty {
                            cell.taskTextView.textColor = .tertiaryLabel
                            cell.taskTextView.text = "Type task here..."
                        } else {
                            cell.taskTextView.textColor = .label
                            cell.taskTextView.text = actions[indexPath.row - 1].text
                        }
                        
                        cell.actionID = actions[indexPath.row - 1].id
                        cell.delegate = self
                        
                        cell.textDidChange = {
                            self.tableView.beginUpdates()
                            self.tableView.endUpdates()
                        }
                        
                        return cell
                    }
                }
            } else {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "isBudgetCell") as! ProjectIsBudbetCell
                    
                    cell.delegate = self
                    cell.isBudgetSwitch.isOn = projectObject.isBudget
                    
                    return cell
                } else if projectObject.isBudget && indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "profitCell") as! ProjectProfitCell
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = NumberFormatter.Style.currency
                    formatter.currencySymbol = ""
                    formatter.locale = Locale.current
                    
                    if Settings.shared.recordCentsOn! {
                        formatter.minimumFractionDigits = 2
                        formatter.maximumFractionDigits = 2
                    } else {
                        formatter.minimumFractionDigits = 0
                        formatter.maximumFractionDigits = 0
                    }
                    
                    let profit = projectObject.budget - projectObject.balance
                    if profit > 0 {
                        cell.profitView.backgroundColor = .green
                        cell.profitLabel.text = "+\(formatter.string(from: NSNumber(value: profit)) ?? "0")"
                    } else if profit < 0 {
                        cell.profitView.backgroundColor = .red
                        cell.profitLabel.text = formatter.string(from: NSNumber(value: profit))
                    } else {
                        cell.profitView.backgroundColor = .tertiaryLabel
                        cell.profitLabel.text = formatter.string(from: NSNumber(value: 0))
                    }
                    
                    cell.profitView.layer.cornerRadius = cell.profitView.frame.height / 4
                    
                    if let localeIdentifier = Settings.shared.chosenLocaleIdentifier {
                        cell.profitCurrencyLabel.text = " \(String(describing: Locale.init(identifier: localeIdentifier).currencySymbol!))"
                    } else {
                        if var localeCurrency = Locale.current.currencySymbol {
                            if localeCurrency == "RUB" { localeCurrency = "₽" }
                            cell.profitCurrencyLabel.text = " \(localeCurrency)"
                        }
                    }
                    
                    return cell
                } else if projectObject.isBudget && indexPath.row == 2 || !isBudget && indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "noTasksCell")!
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "addActionCell") as! AddActionCell
                    cell.delegate = self
                    return cell
                }
            }
        }
    }
}
