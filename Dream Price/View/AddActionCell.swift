//
//  AddActionCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 29.08.2020.
//

import UIKit

protocol AddActionDelegate {
    func addAction()
}

class AddActionCell: UITableViewCell {
    
    var delegate: AddActionDelegate?

    @IBAction func addAction(_ sender: UIButton) {
        delegate?.addAction()
    }
}
