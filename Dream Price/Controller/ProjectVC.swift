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
        // menu with finish and delete project
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
            // title saving
        } else {
            // description saving
        }
    }
    
    func addAction() {
        print("added action")
        // TODO: creating action
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
                cell.taskTextField.text = actions[indexPath.row].text
                
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
