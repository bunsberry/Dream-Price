//
//  NewEarningCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

class NewEarningCell: UITableViewCell {
    
    var delegate: NewCategoryDelegate?

    @IBAction func categoryAdded(_ sender: UITextField) {
        if sender.text == "" {
            return
        }
        
        if let text = sender.text {
            print(text)
            delegate?.addNewCategory(category: text, type: .earning)
            sender.text = ""
        }
    }

}
