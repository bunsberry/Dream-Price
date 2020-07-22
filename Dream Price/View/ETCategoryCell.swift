//
//  TextFieldCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

class ETCategoryCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    var delegate: TransactionDelegate?
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        delegate?.rewriteCategory(string: sender.text!)
    }
    
}
