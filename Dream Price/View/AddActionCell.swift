//
//  AddActionCell.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 29.08.2020.
//

import UIKit

protocol ProjectEditDelegate {
    func addAction()
    func deleteAction(id: String)
    func isBudgetChangedTo(_ state: Bool)
    func budgetNumChangedTo(_ num: Float)
}

class AddActionCell: UITableViewCell {
    
    var delegate: ProjectEditDelegate?

    @IBAction func addAction(_ sender: UIButton) {
        delegate?.addAction()
    }
}
