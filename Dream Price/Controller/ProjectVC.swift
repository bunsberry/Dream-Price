//
//  ProjectVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 26.08.2020.
//

import UIKit

class ProjectVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var actions = [Action(id: UUID().uuidString, projectID: "", text: "Task", completed: false, dateCompleted: nil)]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Приложение"
    }
    
    @IBAction func editActions(_ sender: UIButton) {
        
    }
    
    @IBAction func done(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ProjectVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell") as! ActionCell
        
        cell.checkmarkButton.isSelected = actions[indexPath.row].completed
        cell.taskTextField.text = actions[indexPath.row].text
        
        return cell
    }
}
