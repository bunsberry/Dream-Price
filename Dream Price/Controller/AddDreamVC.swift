//
//  AddDreamVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

class AddDreamVC: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var sumField: UITextField!
    @IBOutlet weak var mainSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func sw() -> DreamType {
        if mainSwitch.isOn {
            return DreamType.focusedDream
        } else {
            return DreamType.dream
        }
    }
    @IBAction func addDream(_ sender: Any) {
        if nameField.text != nil && descriptionField.text != nil && sumField.text != nil {
            let sum = Float(sumField.text!)
            DreamsList.append(Dream(type: sw(), title: nameField.text!, description: descriptionField.text!, balance: 0, goal: sum!, dateAdded: Date()))
        }
        print(DreamsList)
    }
}
