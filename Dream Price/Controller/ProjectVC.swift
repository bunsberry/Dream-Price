//
//  ProjectVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 26.08.2020.
//

import UIKit

class ProjectVC: UIViewController, UITextViewDelegate, AddActionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    public static var isNewProject: Bool = false
    // TODO: Delegating project id
    public static var projectID: String = UUID().uuidString
    
    var actions: [Action] = [Action(id: UUID().uuidString, projectID: "", text: "", completed: false, dateCompleted: nil)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ProjectVC.isNewProject == true {
            titleTextView.text = "Title"
            detailsTextView.text = "Description..."
            titleTextView.textColor = .tertiaryLabel
            detailsTextView.textColor = .tertiaryLabel
        } else {
            // TODO: getting data from DB
            // if db details is empty then
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreOptions(_ sender: UIButton) {
        let moreOptionsMenu = UIAlertController(title: NSLocalizedString("Project Options", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let finishAction = UIAlertAction(title: NSLocalizedString("Finish Project", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let finishMenu = UIAlertController(title: NSLocalizedString("Project Options", comment: ""), message: nil, preferredStyle: .alert)
            
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
            
            let deleteMenu = UIAlertController(title: NSLocalizedString("Project Options", comment: ""), message: nil, preferredStyle: .alert)
            
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
        print("added action")
        // TODO: creating action
        if actions.count == 0 {
            actions.append(Action(id: UUID().uuidString, projectID: ProjectVC.projectID, text: "", completed: false, dateCompleted: nil))
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        } else {
            actions.append(Action(id: UUID().uuidString, projectID: ProjectVC.projectID, text: "", completed: false, dateCompleted: nil))
            tableView.insertRows(at: [IndexPath(row: actions.count - 1, section: 0)], with: .automatic)
        }
    }
}

extension ProjectVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if actions.count == 0 {
            tableView.separatorStyle = .none
            return 2
        } else {
            return actions.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if actions.count != 0 {
            if indexPath.row == actions.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addActionCell") as! AddActionCell
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell") as! ActionCell
                
                cell.checkmarkButton.isSelected = actions[indexPath.row].completed
                if actions[indexPath.row].text.isEmpty {
                    cell.taskTextView.textColor = .tertiaryLabel
                    cell.taskTextView.text = "Type task here..."
                } else {
                    cell.taskTextView.textColor = .label
                    cell.taskTextView.text = actions[indexPath.row].text
                }
                
                cell.textDidChange = {
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "noTasksCell")!
                
                return cell
            } else {
                // add task cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "addActionCell") as! AddActionCell
                cell.delegate = self
                return cell
            }
        }
    }
}
