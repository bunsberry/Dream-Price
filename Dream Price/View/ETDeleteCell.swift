//
//  ETDeleteCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 19.07.2020.
//

import UIKit

class ETDeleteCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    var delegate: TransactionDelegate?
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        self.delegate?.deleteTransaction()
    }
    
}
