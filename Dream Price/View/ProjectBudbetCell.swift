//
//  ProjectBudbetCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 02.09.2020.
//

import UIKit

class ProjectBudbetCell: UITableViewCell {

    @IBOutlet weak var budgetTextField: UITextField!
    
    var delegate: ProjectEditDelegate?
    
    override class func awakeFromNib() {
        print("profit appeared")
    }
    
    @IBAction func projectBudgetChanged(_ sender: UITextField) {
        if let num = Float(sender.text!) {
            delegate?.budgetNumChangedTo(num)
        } else {
            delegate?.budgetNumChangedTo(0)
        }
    }

}
