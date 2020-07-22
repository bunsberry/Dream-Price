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
    var id: String!
    var desc: String!
    var number: Float!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
