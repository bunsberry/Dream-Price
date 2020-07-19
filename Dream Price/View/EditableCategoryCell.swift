//
//  EditableCategoryCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

class EditableCategoryCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    var id: Int!
    
    @IBAction func titleChanged(_ sender: UITextField) {
        // TODO: DB Title change (id is here if that helps)
        print("\(String(describing: id)): Title changed to \(String(describing: sender.text))")
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
