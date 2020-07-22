//
//  NewEarningCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

class NewEarningCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    var delegate: CategoryManageDelegate?

    @IBAction func categoryAdded(_ sender: UITextField) {
        if textField.text != "" {
            print(textField.text)
            delegate?.addNewCategory(category: textField.text!, type: .earning)
            textField.text = ""
        }
    }

}
