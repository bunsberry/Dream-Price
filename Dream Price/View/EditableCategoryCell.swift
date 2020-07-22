//
//  EditableCategoryCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

class EditableCategoryCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    var id: String!
    var firstTitle: String!
    
    var delegate: CategoryManageDelegate?
    
    @IBAction func titleChanged(_ sender: UITextField) {
        if sender.text != "" {
            delegate?.categoryEdited(id: id, title: sender.text!)
            firstTitle = sender.text!
            sender.text = firstTitle
        } else {
            sender.text = firstTitle
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if editing == true {
            titleTextField.isEnabled = true
        } else {
            titleTextField.isEnabled = false
        }

        super.setEditing(editing, animated: animated)
    }
    
}
