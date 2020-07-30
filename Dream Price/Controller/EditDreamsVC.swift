//
//  EditDreamVC.swift
//  Dream Price
//
//  Created by Noisegain on 19.07.2020.
//

import UIKit

protocol EditDreamDelegate {
    func dreamEdited(dream: Dream, row: Int)
    func dreamDeleted(dreamID: String, row: Int)
}

public var selectedDreamToEdit = 0

class EditDreamsVC: UITableViewController, UITextFieldDelegate {
    
    static public var delegate: EditDreamDelegate?
    
    var selectedRow = 0
    static public var dreamID = ""
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var sumField: UITextField!
    @IBOutlet weak var mainSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedRow = selectedDreamToEdit
        
        nameField.text = dreamsList[selectedRow].title
        descriptionField.text = dreamsList[selectedRow].description
        sumField.delegate = self
        
        let numberFormatter = NumberFormatter()
        
        if Settings.shared.recordCentsOn! {
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.minimumFractionDigits = 2
            sumField.keyboardType = .decimalPad
        } else {
            numberFormatter.maximumFractionDigits = 0
            numberFormatter.minimumFractionDigits = 0
            sumField.keyboardType = .numberPad
        }
        
        sumField.text = numberFormatter.string(from: NSNumber(value: dreamsList[selectedRow].goal))
        
        if dreamsList[selectedRow].type == .focusedDream {
            mainSwitch.setOn(true, animated: false)
        }
        
        tableView.allowsSelection = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        nameField.text = ""
        descriptionField.text = ""
        sumField.text = ""
        mainSwitch.setOn(false, animated: false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
    
    func sw() -> DreamType {
        if mainSwitch.isOn {
            return DreamType.focusedDream
        } else {
            return DreamType.dream
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func EditDream(_ sender: Any) {
        
        if nameField.text != "" && sumField.text != "" {
            
            var sum: Float = 0
            
            if Settings.shared.recordCentsOn! {
                let numberFormatter = NumberFormatter()
                numberFormatter.decimalSeparator = ","
                sum = Float(truncating: numberFormatter.number(from: sumField.text!)!)
            } else {
                sum = Float(sumField.text!)!
            }
            
            let dream = Dream(dreamID: EditDreamsVC.dreamID, type: sw(), title: nameField.text!, description: descriptionField.text!, balance: 0, goal: sum, dateAdded: dreamsList[selectedRow].dateAdded)
            
            EditDreamsVC.delegate?.dreamEdited(dream: dream, row: selectedRow)
            
            dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("Something went wrong...", comment: ""), message: NSLocalizedString("Fill in all the required information", comment: ""), preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .default))

            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func delete() {
        let deleteMenu = UIAlertController(title: NSLocalizedString("Are you sure?", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            // TODO: Deleting from database
            EditDreamsVC.delegate?.dreamDeleted(dreamID: EditDreamsVC.dreamID, row: self.selectedRow)
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        deleteMenu.addAction(deleteAction)
        deleteMenu.addAction(cancelAction)
        
        self.present(deleteMenu, animated: true, completion: nil)
    }
}
