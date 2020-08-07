//
//  AddProjectCVCell.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import UIKit

class AddProjectCVCell: UICollectionViewCell {
    
    @IBOutlet weak var addProjectLabel: UILabel!
    @IBOutlet weak var plusLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.backgroundColor = UIColor.clear.cgColor
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        contentView.addDashedBorder(color: UIColor(red: 0.842, green: 0.477, blue: 0.477, alpha: 1).cgColor, lineWidth: 3, patternLength: 12, cornerRadius: self.frame.size.width / 10)
        contentView.layer.cornerRadius = self.frame.size.width / 10
    }
    
    override func prepareForReuse() {
//        contentView.layer.sublayers = []
    }
}
