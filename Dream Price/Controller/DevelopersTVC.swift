//
//  DevelopersTVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 31.07.2020.
//

import UIKit

class DevelopersTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var destinationURL: URL!
        
        switch indexPath {
        case IndexPath(row: 0, section: 0): destinationURL = URL(string: "https://twitter.com/DreamPriceApp")
        case IndexPath(row: 1, section: 0): destinationURL = URL(string: "https://google.com")
        case IndexPath(row: 0, section: 1): destinationURL = URL(string: "https://twitter.com/KostyaBunsberry")
        default: print("undefined index path")
        }
        
        UIApplication.shared.open(destinationURL)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
