//
//  ProjectVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 26.08.2020.
//

import UIKit

class ProjectVC: UIViewController, UITextViewDelegate, ProjectEditDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    var isNewProject: Bool!
    var projectID: String!
    var isBudget: Bool = false
    
    var actions: [Action] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isNewProject == true {
            titleTextView.text = "Title"
            detailsTextView.text = "Description..."
            titleTextView.textColor = .tertiaryLabel
            detailsTextView.textColor = .tertiaryLabel
            doneButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        } else {
            // TODO: getting data from DB
            // if db details is empty then
            doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
            if detailsTextView.text == "Description..." {
                detailsTextView.text = "Description..."
                detailsTextView.textColor = .tertiaryLabel
            }
        }
        
        titleTextView.delegate = self
        detailsTextView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @IBAction func done(_ sender: UIButton) {
        if doneButton.title(for: .normal) == NSLocalizedString("Save", comment: "") {
            if titleTextView.text != "" && titleTextView.textColor != .tertiaryLabel {
                if isBudget == true {
                    let budgetCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ProjectBudbetCell
                    
                    if budgetCell.budgetTextField.text != "" {
                        // TODO: Wrtiting to db cells data
                        isNewProject = false
                        if isBudget {
                            tableView.beginUpdates()
                            tableView.reloadRows(at: [IndexPath(row: 0, section: 0),
                                                      IndexPath(row: 1, section: 0)], with: .automatic)
                            tableView.insertRows(at: [IndexPath(row: 2, section: 0),
                                                      IndexPath(row: 3, section: 0)], with: .automatic)
                            tableView.endUpdates()
                        } else {
                            tableView.beginUpdates()
                            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                            tableView.insertRows(at: [IndexPath(row: 1, section: 0),
                                                      IndexPath(row: 2, section: 0)], with: .automatic)
                            tableView.endUpdates()
                        }
                        
                        doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
                    } else {
                        let alert = UIAlertController(title: NSLocalizedString("Fill in all the required information", comment: ""), message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: nil))
                        present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Fill in all the required information", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
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
            
            if isBudget {
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
            
            if isBudget {
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
                    if isBudget {
                        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                    } else {
                        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                    }
                } else {
                    if isBudget {
                        tableView.deleteRows(at: [IndexPath(row: index + 2, section: 0)], with: .automatic)
                    } else {
                        tableView.deleteRows(at: [IndexPath(row: index + 1, section: 0)], with: .automatic)
                    }
                }
            }
        }
    }
    
    func isBudgetChangedTo(_ state: Bool) {
        isBudget = state
        
        // TODO: db change state
        
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
}

extension ProjectVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isNewProject {
            // Создание проекта
            if isBudget {
                return 2
            } else {
                return 1
            }
        } else {
            // Открытие существующего проекта
            if isBudget {
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
            if isBudget {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "isBudgetCell") as! ProjectIsBudbetCell
                    
                    cell.isBudgetSwitch.isOn = isBudget
                    cell.delegate = self
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "budgetCell") as! ProjectBudbetCell
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "isBudgetCell") as! ProjectIsBudbetCell
                
                cell.isBudgetSwitch.isOn = isBudget
                cell.delegate = self
                
                return cell
            }
        } else {
            // Saved project cells
            if actions.count != 0 {
                if isBudget {
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "isBudgetCell") as! ProjectIsBudbetCell
                        
                        cell.delegate = self
                        cell.isBudgetSwitch.isOn = isBudget
                        
                        return cell
                    } else if indexPath.row == 1 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "profitCell") as! ProjectProfitCell
                        
                        // TODO: Profit data insert
                        
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
                        cell.isBudgetSwitch.isOn = isBudget
                        
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
                    cell.isBudgetSwitch.isOn = isBudget
                    
                    return cell
                } else if isBudget && indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "profitCell") as! ProjectProfitCell
                    
                    // TODO: get from db the profit
                    
                    return cell
                } else if isBudget && indexPath.row == 2 || !isBudget && indexPath.row == 1 {
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
