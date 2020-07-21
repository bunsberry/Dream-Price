//
//  EditDreamVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

protocol EditDreamDelegate {
    func dreamEdited(dream: Dream, row: Int)
}

public var selectedDreamToEdit = 0

class EditDreamVC: UITableViewController {
    
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
        print(selectedRow)
        nameField.text = dreamsList[selectedRow].title
        descriptionField.text = dreamsList[selectedRow].description
        sumFIeld.text = "\(dreamsList[selectedRow].goal)"
        if dreamsList[selectedRow].type == .focusedDream {
            mainSwitch.setOn(true, animated: false)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("ssss")
        nameField.text = ""
        descriptionField.text = ""
        sumFIeld.text = ""
        mainSwitch.setOn(false, animated: false)
    }
    public func update() {
        
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
            let dream = Dream(type: sw(), title: nameField.text!, description: descriptionField.text!, balance: 0, goal: sum!, dateAdded: Date())
            EditDreamVC.delegate?.dreamEdited(dream: dream, row: selectedRow)
            dismiss(animated: true, completion: nil)
        } else {
            // TODO: Notification that you didn't type everything
        }
    }

}


