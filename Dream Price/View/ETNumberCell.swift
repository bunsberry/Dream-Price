//
//  ETNumberCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

class ETNumberCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    var delegate: TransactionDelegate?
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        
    }
    
    @IBAction func textFieldEnded(_ sender: UITextField) {
        if sender.text != "" || sender.text != "-" || sender.text != "+" {
            if let newValue = Float(sender.text!) {
                delegate?.rewriteNumber(float: newValue)
            }
        }
    }
    
}
