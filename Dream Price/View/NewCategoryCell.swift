//
//  NewCategoryCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

class NewCategoryCell: UITableViewCell {
    
    var delegate: NewCategoryDelegate?
    
    @IBAction func categoryTyped(_ sender: UITextField) {
        if sender.text == "" {
            return
        }
        
        if let text = sender.text {
            print(text)
            delegate?.addNewCategory(category: text, type: .spending)
            sender.text = ""
        }
    }
    
    
}
