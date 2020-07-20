//
//  AddDreamVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit
/*
protocol RefreshDataDelegate {
  func refreshData()
}
*/
class AddDreamVC: UITableViewController {
    
    
    //var viewDelegate: RefreshDataDelegate?
    //typealias completion = (Bool)->Void
    //var addCompletion: completion!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var sumField: UITextField!
    @IBOutlet weak var mainSwitch: UISwitch!
    var instanceofDreamVC: DreamsVC!
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
        dismiss(animated: true, completion: {
            DreamsVC().dreamCollection?.reloadData()
        })
        //self.addCompletion(true)
        print(DreamsList)
    }
}


