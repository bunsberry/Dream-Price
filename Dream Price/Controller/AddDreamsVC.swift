//
//  AddDreamVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

protocol AddDreamDelegate {
    func dreamAdded(newDream: Dream)
}

class AddDreamsVC: UITableViewController, UITextFieldDelegate {
    
    public var delegate: AddDreamDelegate?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var sumField: UITextField!
    @IBOutlet weak var mainSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        sumField.delegate = self
        
        tableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupTextFields()
    }
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero,
                                              size: .init(width: view.frame.size.width, height: 30)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self,
                                         action: #selector(doneButtonAction))
        doneButton.tintColor = UIColor(red: 0.443, green: 0.541, blue: 0.792, alpha: 1)
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        
        sumField.inputAccessoryView = toolbar
        nameField.inputAccessoryView = toolbar
        descriptionField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
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
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addDream(_ sender: Any) {
        if nameField.text != "" && sumField.text != "" {
            
            var sum: Float = 0
            
            if Settings.shared.recordCentsOn! {
                let numberFormatter = NumberFormatter()
                numberFormatter.decimalSeparator = ","
                sum = Float(truncating: numberFormatter.number(from: sumField.text!)!)
            } else {
                sum = Float(sumField.text!)!
            }
            
            let newDream = Dream(dreamID: UUID().uuidString, type: sw(), title: nameField.text!, description: descriptionField.text!, balance: 0, goal: sum, dateAdded: Date())
            self.delegate?.dreamAdded(newDream: newDream)
            self.navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("Something went wrong...", comment: ""), message: NSLocalizedString("Fill in all the required information", comment: ""), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .default))

            self.present(alertController, animated: true, completion: nil)
        }
    }
}


