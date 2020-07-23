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

class AddDreamsVC: UITableViewController {
    
    static public var delegate: AddDreamDelegate?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var sumField: UITextField!
    @IBOutlet weak var mainSwitch: UISwitch!
    
    // TODO: sumField formatter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
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
    
    
    @IBAction func addDream(_ sender: Any) {
        if nameField.text != "" && sumField.text != "" {
            let sum = Float(sumField.text!)
            let newDream = Dream(dreamID: UUID().uuidString, type: sw(), title: nameField.text!, description: descriptionField.text!, balance: 0, goal: sum!, dateAdded: Date())
            AddDreamsVC.delegate?.dreamAdded(newDream: newDream)
            dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("Something went wrong...", comment: ""), message: NSLocalizedString("Fill in all the required information", comment: ""), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .default))

            self.present(alertController, animated: true, completion: nil)
        }
    }
}

