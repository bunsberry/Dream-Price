//
//  NewCategoryCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

class NewCategoryCell: UITableViewCell {
    
    var delegate: CategoryManageDelegate?
    
    @IBAction func categoryTyped(_ sender: UITextField) {
        if sender.text != "" {
            print(sender.text)
            delegate?.addNewCategory(category: sender.text!, type: .spending)
            sender.text = ""
        }
    }
    
}
