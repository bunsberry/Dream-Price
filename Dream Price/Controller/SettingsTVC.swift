//
//  SettingsTVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 26.07.2020.
//

import UIKit

class SettingsTVC: UITableViewController {
    
    @IBOutlet weak var recordCentsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordCentsSwitch.setOn(Settings.shared.recordCentsOn ?? false, animated: false)
        self.clearsSelectionOnViewWillAppear = true
    }
    
    @IBAction func recordCentsChanged(_ sender: UISwitch) {
        Settings.shared.recordCentsOn = sender.isOn
    }
    
    @IBAction func done() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
