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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCentsFooter()
    }
    
    @IBAction func recordCentsChanged(_ sender: UISwitch) {
        Settings.shared.recordCentsOn = sender.isOn
        setCentsFooter()
        print(Settings.shared.recordCentsOn)
    }
    
    func setCentsFooter() {
        var locale = Locale.current
        if Locale.current.currencySymbol == "RUB" {
            locale = Locale(identifier: "ru_RU")
        }
        
        if recordCentsSwitch.isOn {
            tableView.footerView(forSection: 1)?.textLabel?.text = "Транзакции будут записаны как 20,25 \(locale.currencySymbol ?? "$")"
        } else {
            tableView.footerView(forSection: 1)?.textLabel?.text = "Транзакции будут записаны как 20 \(locale.currencySymbol ?? "$")"
        }
    }
    
    
    @IBAction func done() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
