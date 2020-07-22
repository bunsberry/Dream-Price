//
//  ETNumberCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

class ETNumberCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    var delegate: TransactionDelegate?
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func textFieldAccessed(_ sender: Any) {
        textField.delegate = self
    }
    
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if sender.text != "" && sender.text != "-" && sender.text != "+" {
            if let newValue = Float(sender.text!) {
                delegate?.rewriteNumber(float: newValue)
            }
        } else {
            delegate?.rewriteNumber(float: 0)
        }
    }
    
    @IBAction func textFieldEnded(_ sender: UITextField) {
        if sender.text == "-" || sender.text == "+" {
            delegate?.rewriteNumber(float: 0)
        }
    }
    
}
