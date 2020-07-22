//
//  EditDreamVC.swift
//  Dream Price
//
//  Created by Noisegain on 19.07.2020.
//

import UIKit

protocol EditDreamDelegate {
    func dreamEdited(dream: Dream, row: Int)
}

public var selectedDreamToEdit = 0

class EditDreamsVC: UITableViewController {
    
    static public var delegate: EditDreamDelegate?
    
    var selectedRow = 0
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var sumFIeld: UITextField!
    @IBOutlet weak var mainSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedRow = selectedDreamToEdit
        
        nameField.text = dreamsList[selectedRow].title
        descriptionField.text = dreamsList[selectedRow].description
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.minimumFractionDigits = 0
        
        sumFIeld.text = numberFormatter.string(from: NSNumber(value: dreamsList[selectedRow].goal))
        
        if dreamsList[selectedRow].type == .focusedDream {
            mainSwitch.setOn(true, animated: false)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        nameField.text = ""
        descriptionField.text = ""
        sumFIeld.text = ""
        mainSwitch.setOn(false, animated: false)
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
        if nameField.text != "" && sumFIeld.text != "" {
            let sum = Float(sumFIeld.text!)
            let dream = Dream(type: sw(), title: nameField.text!, description: descriptionField.text!, balance: 0, goal: sum!, dateAdded: dreamsList[selectedRow].dateAdded)
            EditDreamsVC.delegate?.dreamEdited(dream: dream, row: selectedRow)
            dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("Something went wrong...", comment: ""), message: NSLocalizedString("Fill in all the required information", comment: ""), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .default))

            self.present(alertController, animated: true, completion: nil)
        }
    }

}


