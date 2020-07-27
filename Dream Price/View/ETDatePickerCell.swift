//
//  ETDatePickerCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 28.07.2020.
//

import UIKit

class ETDatePickerCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: TransactionDelegate?
    
    @IBAction func dateChanged() {
        delegate?.rewriteDate(date: datePicker.date)
    }

}
