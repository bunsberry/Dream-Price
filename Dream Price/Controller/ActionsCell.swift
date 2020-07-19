//
//  ActionsCell.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import UIKit

class ActionsCell: UITableViewCell {
    @IBOutlet weak var completionMark: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configure(name: String, details: String, date: NSDate) {
        self.name.text = name
        self.details.text = details
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
