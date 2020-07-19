//
//  ETDescriptionCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

class ETDescriptionCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    var delegate: TransactionDelegate?
    
    @IBAction func desctriptionChanged(_ sender: UITextField) {
        delegate?.rewriteDesctiption(string: sender.text!)
    }
}
