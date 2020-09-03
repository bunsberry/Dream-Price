//
//  ProjectIsBudbetCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 02.09.2020.
//

import UIKit

class ProjectIsBudbetCell: UITableViewCell {

    @IBOutlet weak var isBudgetSwitch: UISwitch!
    
    var delegate: ProjectEditDelegate?
    
    @IBAction func isBudgetChanged(_ sender: UISwitch) {
        print("switch value changed")
        delegate?.isBudgetChangedTo(sender.isOn)
    }

}
