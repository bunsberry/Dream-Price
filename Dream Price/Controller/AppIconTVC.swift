//
//  AppIconTVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 26.07.2020.
//

import UIKit

class AppIconTVC: UITableViewController {

    var starterIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        switch UIApplication.shared.alternateIconName {
        case "AppIconYellow":
            starterIndexPath = IndexPath(row: 1, section: 0)
        case "AppIconRed":
            starterIndexPath = IndexPath(row: 2, section: 0)
        case "AppIconBlue":
            starterIndexPath = IndexPath(row: 3, section: 0)
        case "AppIconBlack":
            starterIndexPath = IndexPath(row: 4, section: 0)
        default:
            starterIndexPath = IndexPath(row: 0, section: 0)
        }
        
        tableView.cellForRow(at: starterIndexPath)?.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: starterIndexPath)?.accessoryType = .none
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        var newIcon: String?
        
        switch indexPath.row {
        case 0: newIcon = nil
        case 1: newIcon = "AppIconYellow"
        case 2: newIcon = "AppIconRed"
        case 3: newIcon = "AppIconBlue"
        case 4: newIcon = "AppIconBlack"
        default: print("Unknown Row")
        }
        
        UIApplication.shared.setAlternateIconName(newIcon, completionHandler: nil)
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
