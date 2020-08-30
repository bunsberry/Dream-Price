//
//  CompletedActionCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 30.08.2020.
//

import UIKit

protocol CompletedActionDelegate {
    func removedCompletition(id: String)
}

class CompletedActionCell: UITableViewCell {
    
    @IBOutlet weak var completitionButton: UIButton!
    @IBOutlet weak var textTextView: UITextView!
    
    var actionID: String!
    var delegate: CompletedActionDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func decompletedAction(_ sender: UIButton) {
        if sender.isSelected == true {
            UIView.transition(with: sender, duration: 0.3, options: .transitionCrossDissolve, animations: {
                sender.isSelected = false
            }, completion: { Void in
                print(self.actionID)
                self.delegate?.removedCompletition(id: self.actionID!)
            })
        }
//        sender.isSelected = false
    }

}
