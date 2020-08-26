//
//  ActionCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 26.08.2020.
//

import UIKit

class ActionCell: UITableViewCell {
    
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var taskTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkmarkTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }

}
