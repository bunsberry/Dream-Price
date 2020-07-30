//
//  CurrencyTVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 31.07.2020.
//

import UIKit

class CurrencyTVC: UITableViewController {
    
    let commonCurrencyIdentifiers: [String] = ["en_US", "fr_FR", "en_GB", "ru_RU"]
    var starterIndexPath: IndexPath = IndexPath(row: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch Settings.shared.chosenLocaleIdentifier {
        case nil:
            starterIndexPath = IndexPath(row: 0, section: 0)
        case "en_US":
            starterIndexPath = IndexPath(row: 0, section: 1)
        case "fr_FR":
            starterIndexPath = IndexPath(row: 1, section: 1)
        case "en_GB":
            starterIndexPath = IndexPath(row: 2, section: 1)
        case "ru_RU":
            starterIndexPath = IndexPath(row: 3, section: 1)
        default:
            starterIndexPath = IndexPath(row: 0, section: 0)
        }
        
        print(starterIndexPath)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return commonCurrencyIdentifiers.count
        default: return 0
        }
    }
    
    func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: Locale.current.identifier)
        return current.localizedString(forRegionCode: countryCode)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)

            var locale = Locale.current
            if locale.currencyCode == "RUB" {
                locale = Locale.init(identifier: "ru_RU")
            }
            
            if starterIndexPath == indexPath {
                cell.accessoryType = .checkmark
            }
            
            cell.textLabel?.text = "\(String(describing: locale.currencySymbol!)) - \(String(describing: countryName(countryCode: locale.regionCode!)!))"

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
            
            if starterIndexPath == indexPath {
                cell.accessoryType = .checkmark
            }

            let locale = Locale.init(identifier: commonCurrencyIdentifiers[indexPath.row])
            cell.textLabel?.text = "\(String(describing: locale.currencySymbol!)) - \(String(describing: countryName(countryCode: locale.regionCode!)!))"

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Рекомендовано"
        case 1: return "Часто встречающиеся валюты"
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Это валюта, относящаяся к вашему региону, выставленному на телефоне."
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: starterIndexPath)?.accessoryType = .none
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        var newIdentifier: String?
        
        switch indexPath {
        case IndexPath(row: 0, section: 0): newIdentifier = nil
        case IndexPath(row: 0, section: 1): newIdentifier = "en_US"
        case IndexPath(row: 1, section: 1): newIdentifier = "fr_FR"
        case IndexPath(row: 2, section: 1): newIdentifier = "en_GB"
        case IndexPath(row: 3, section: 1): newIdentifier = "ru_RU"
        default: print("Unknown Row")
        }
        
        Settings.shared.chosenLocaleIdentifier = newIdentifier
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
