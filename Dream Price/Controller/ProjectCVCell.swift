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
    @IBOutlet weak var budgetDifferenceLabel: UILabel!
    @IBOutlet weak var budgetDifferenceView: UIView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
