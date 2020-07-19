//
//  ProjectCVCell.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import UIKit

class ProjectCVCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var details: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(name: String, details: String) {
        self.name.text = name
        self.details.text = details
    }
}
