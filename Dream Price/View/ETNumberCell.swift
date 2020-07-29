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
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }

            let newText = oldText.replacingCharacters(in: r, with: string)
            let numberOfDots = newText.components(separatedBy: ",").count - 1
            
            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ",") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }

            return numberOfDots <= 1 && numberOfDecimalDigits <= 2
        }
    }
    
    @IBAction func textFieldAccessed(_ sender: Any) {
        textField.delegate = self
        
        if Settings.shared.recordCentsOn! {
            textField.keyboardType = .decimalPad
        } else {
            textField.keyboardType = .numberPad
        }
    }
    
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if sender.text != "" && sender.text != "-" && sender.text != "+" {
            let newValue: Float
            var stringValue: String = sender.text!
            
            if sender.text?.first == "+" { stringValue.removeFirst() }
            
            if Settings.shared.recordCentsOn! {
                let numberFormatter = NumberFormatter()
                numberFormatter.decimalSeparator = ","
                newValue = Float(truncating: numberFormatter.number(from: stringValue)!)
            } else {
                newValue = Float(sender.text!)!
            }
            
            delegate?.rewriteNumber(float: newValue)
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
