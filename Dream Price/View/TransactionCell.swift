//
//  TransactionCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 17.07.2020.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    var date: Date!
    var transactionID: String!
    var categoryID: String?
    var budgetFromID: String!
    var budgetToID: String?
    var amount: Float!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
